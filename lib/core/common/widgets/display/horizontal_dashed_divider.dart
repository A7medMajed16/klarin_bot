import 'package:material_ui/material_ui.dart';

class HorizontalDashedDivider extends StatelessWidget {
  final Color color;
  final double dashLength;
  final double dashGap;
  final double thickness;

  const HorizontalDashedDivider({
    super.key,
    required this.color,
    this.dashLength = 5.0,
    this.dashGap = 3.0,
    this.thickness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, thickness),
      painter: _DashedLinePainter(
        color: color,
        dashLength: dashLength,
        dashGap: dashGap,
        thickness: thickness,
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashLength;
  final double dashGap;
  final double thickness;

  _DashedLinePainter({
    required this.color,
    required this.dashLength,
    required this.dashGap,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    double startX = 0;
    final double y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashLength, y),
        paint,
      );
      startX += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.dashLength != dashLength ||
      oldDelegate.dashGap != dashGap ||
      oldDelegate.thickness != thickness;
}
