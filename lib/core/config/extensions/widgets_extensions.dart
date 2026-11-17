import 'dart:ui' show PathMetric;

import 'package:material_ui/material_ui.dart';

import '../../common/widgets/feedback/custom_toast.dart';
import '../../helper/formatters/phone_length_helper.dart';

extension WidgetSliverExtension on Widget {
  Widget toSliver({double? padding}) => padding != null
      ? SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          sliver: SliverToBoxAdapter(child: this),
        )
      : SliverToBoxAdapter(child: this);
}

extension WidgetSliverPaddingExtension on Widget {
  SliverPadding withSliverPadding(EdgeInsetsGeometry padding) =>
      SliverPadding(padding: padding, sliver: this);
}

extension SliverListSpacingExtension on List<Widget> {
  List<Widget> withSliverSpacing(double spacing) {
    if (length <= 1 || spacing == 0) return this;
    final spaced = <Widget>[];
    for (var i = 0; i < length; i++) {
      spaced.add(this[i]);
      if (i != length - 1) {
        spaced.add(SliverToBoxAdapter(child: SizedBox(height: spacing)));
      }
    }
    return spaced;
  }
}

extension PhoneTextEditingControllerExtension on TextEditingController {
  static final Map<TextEditingController, String> _countryCodes = {};
  String get selectedCountryCode => _countryCodes[this] ?? '964';
  void updateSelectedCountryCode(String countryCode) {
    _countryCodes[this] = countryCode;
  }

  String get fullPhoneNumber => '+$selectedCountryCode$text';
  String get phoneNumberOnly => text;
  void setPhoneWithCountryCode(String phoneWithCode) {
    if (phoneWithCode.startsWith('+')) {
      final RegExp regExp = RegExp(r'^\+(\d{1,4})(.*)$');
      final match = regExp.firstMatch(phoneWithCode);
      if (match != null) {
        updateSelectedCountryCode(match.group(1)!);
        text = match.group(2)!;
      }
    } else {
      text = phoneWithCode;
    }
  }

  void clearCountryCode() {
    _countryCodes.remove(this);
  }

  void initValue(String phoneWithCode) {
    setPhoneWithCountryCode(
      PhoneLengthHelper.getCountryCode(phoneWithCode) ?? "",
    );
    text = phoneWithCode.replaceRange(
      0,
      PhoneLengthHelper.getCountryCode(phoneWithCode)?.length ?? 0,
      '',
    );
  }

  bool get hasCountryCode => _countryCodes.containsKey(this);
  void initializeCountryCode(String countryCode) {
    if (!hasCountryCode) {
      updateSelectedCountryCode(countryCode);
    }
  }
}

extension ShowCustomToast on String {
  void showSuccessToast({required BuildContext context, String? description}) {
    CustomToast(
      context: context,
      header: this,
      type: .success,
      description: description,
    ).showToast();
  }

  void showErrorToast({required BuildContext context, String? description}) {
    CustomToast(
      context: context,
      header: this,
      description: description,
      type: .error,
    ).showToast();
  }

  void showWarningToast({required BuildContext context, String? description}) {
    CustomToast(context: context, header: this, type: .warning).showToast();
  }

  void showDefaultToast({required BuildContext context, String? description}) {
    CustomToast(
      context: context,
      header: this,
      description: description,
      type: .defaultToast,
    ).showToast();
  }
}

extension DottedBorderExtension on BoxBorder? {
  BoxBorder dotted({
    Color? color,
    double? width,
    double? dashWidth,
    double? gap,
    double? radius,
  }) {
    Color borderColor = color ?? Colors.black;
    double borderWidth = width ?? 1.0;

    if (this is Border) {
      final border = this as Border;
      borderColor = color ?? border.top.color;
      borderWidth = width ?? border.top.width;
    }

    return DashedBorder(
      color: borderColor,
      width: borderWidth,
      dashWidth: dashWidth ?? 5.0,
      gapWidth: gap ?? 3.0,
      radius: radius ?? 0.0,
    );
  }
}

class DashedBorder extends BoxBorder {
  final Color color;
  final double width;
  final double dashWidth;
  final double gapWidth;
  final double radius;

  const DashedBorder({
    required this.color,
    this.width = 1.0,
    this.dashWidth = 5.0,
    this.gapWidth = 3.0,
    this.radius = 0.0,
  });

  @override
  BorderSide get bottom => BorderSide.none;

  @override
  BorderSide get top => BorderSide.none;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    Path path;
    if (shape == BoxShape.circle) {
      path = Path()..addOval(rect);
    } else {
      if (borderRadius != null || radius > 0) {
        path = Path()
          ..addRRect(
            (borderRadius ?? BorderRadius.circular(radius)).toRRect(rect),
          );
      } else {
        path = Path()..addRect(rect);
      }
    }

    final Path dashedPath = _createDashedPath(path, dashWidth, gapWidth);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, double dash, double gap) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len = (distance + dash > metric.length)
            ? metric.length - distance
            : dash;
        dest.addPath(metric.extractPath(distance, distance + len), Offset.zero);
        distance += dash + gap;
      }
    }
    return dest;
  }

  @override
  ShapeBorder scale(double t) {
    return DashedBorder(
      color: color,
      width: width * t,
      dashWidth: dashWidth * t,
      gapWidth: gapWidth * t,
      radius: radius * t,
    );
  }
}
