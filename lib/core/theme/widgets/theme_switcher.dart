import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;

import '../app_animation_curves.dart';

/// Wraps the app shell to provide a premium circular-reveal transition when the
/// theme changes.
///
/// The flow:
/// 1. Snapshot the current screen into a [ui.Image].
/// 2. Paint that snapshot on top of everything.
/// 3. Apply the real theme change underneath (architecture untouched).
/// 4. Wipe the snapshot away with a wavy expanding shape from the tap origin,
///    revealing the freshly themed UI.
///
/// If snapshotting is unavailable (e.g. some web renderers) it gracefully falls
/// back to applying the theme with no animation.
class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key, required this.child});

  final Widget child;

  static ThemeSwitcherState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'No ThemeSwitcher found in context');
    return state!;
  }

  static ThemeSwitcherState? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<_ThemeSwitcherScope>()?.state;
  }

  @override
  State<ThemeSwitcher> createState() => ThemeSwitcherState();
}

class ThemeSwitcherState extends State<ThemeSwitcher>
    with SingleTickerProviderStateMixin {
  final GlobalKey _boundaryKey = GlobalKey();

  late final AnimationController _controller;
  late final Animation<double> _animation;

  ui.Image? _overlayImage;
  Offset _center = Offset.zero;
  double _maxRadius = 0;
  bool _isSwitching = false;

  bool get isSwitching => _isSwitching;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: AppAnimationCurves.androidCurve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlayImage?.dispose();
    super.dispose();
  }

  /// Snapshots the current frame, applies [onApplyTheme], then reveals the new
  /// theme with a wavy circle expanding from [center] (global coordinates).
  Future<void> switchTheme({
    required Offset center,
    required FutureOr<void> Function() onApplyTheme,
  }) async {
    if (_isSwitching) return;

    final boundary =
        _boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) {
      await onApplyTheme();
      return;
    }

    ui.Image image;
    try {
      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      image = await boundary.toImage(pixelRatio: pixelRatio);
    } catch (_) {
      await onApplyTheme();
      return;
    }

    final size = boundary.size;
    final localCenter = boundary.globalToLocal(center);

    setState(() {
      _overlayImage = image;
      _center = localCenter;
      _maxRadius = _farthestCornerDistance(localCenter, size);
      _isSwitching = true;
    });

    // Ensure the snapshot is painted before swapping the theme underneath, so
    // there is never a flash of the new theme.
    await WidgetsBinding.instance.endOfFrame;
    await onApplyTheme();

    try {
      await _controller.forward(from: 0);
    } finally {
      final old = _overlayImage;
      if (mounted) {
        setState(() {
          _overlayImage = null;
          _isSwitching = false;
        });
      } else {
        _overlayImage = null;
        _isSwitching = false;
      }
      old?.dispose();
    }
  }

  double _farthestCornerDistance(Offset center, Size size) {
    final dx = math.max(center.dx, size.width - center.dx);
    final dy = math.max(center.dy, size.height - center.dy);
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeSwitcherScope(
      state: this,
      child: Stack(
        children: [
          RepaintBoundary(key: _boundaryKey, child: widget.child),
          if (_overlayImage != null)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, _) {
                  return ClipPath(
                    clipper: _WavyRevealClipper(
                      center: _center,
                      radius: _maxRadius * _animation.value,
                      wavePhase: _animation.value * math.pi * 2,
                    ),
                    child: RawImage(image: _overlayImage, fit: BoxFit.fill),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ThemeSwitcherScope extends InheritedWidget {
  const _ThemeSwitcherScope({required this.state, required super.child});

  final ThemeSwitcherState state;

  @override
  bool updateShouldNotify(_ThemeSwitcherScope oldWidget) => false;
}

/// Clips out a wavy expanding shape so the old-theme snapshot stays visible
/// outside the reveal boundary (new theme shows through the hole).
class _WavyRevealClipper extends CustomClipper<Path> {
  const _WavyRevealClipper({
    required this.center,
    required this.radius,
    required this.wavePhase,
  });

  final Offset center;
  final double radius;
  final double wavePhase;

  static const int _segments = 128;
  static const int _lobes = 6;
  static const double _amplitude = 0.09;

  Path _wavyCirclePath() {
    if (radius <= 0) {
      return Path()..addRect(const Rect.fromLTWH(0, 0, 0, 0));
    }

    final path = Path();
    for (var i = 0; i <= _segments; i++) {
      final t = i / _segments;
      final angle = t * 2 * math.pi;
      final wave =
          math.sin(angle * _lobes + wavePhase) * _amplitude +
          math.sin(angle * _lobes * 2 - wavePhase * 0.7) * _amplitude * 0.4;
      final r = radius * (1 + wave);
      final point = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  Path getClip(Size size) {
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      _wavyCirclePath(),
    );
  }

  @override
  bool shouldReclip(_WavyRevealClipper oldClipper) =>
      oldClipper.radius != radius ||
      oldClipper.center != center ||
      oldClipper.wavePhase != wavePhase;
}
