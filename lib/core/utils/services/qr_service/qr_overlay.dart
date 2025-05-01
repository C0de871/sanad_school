import 'package:flutter/material.dart';

class QRScannerOverlay extends StatelessWidget {
  final double scanAreaSize;
  final double animationValue;
  final bool isDetected;

  // Customization options
  final Color overlayColor;
  final Color cornerColor;
  final Color lineColor;
  final double cornerThickness;
  final double lineThickness;
  final double cornerLength;
  final double cornerRadius;
  final double scanLineMargin; // Margin from the border in pixels

  const QRScannerOverlay({
    super.key,
    required this.scanAreaSize,
    required this.animationValue,
    required this.isDetected,
    this.overlayColor = Colors.black,
    this.cornerColor = Colors.white,
    this.lineColor = Colors.white,
    this.cornerThickness = 5.0,
    this.lineThickness = 2.0,
    this.cornerLength = -1, // Default to auto-calculation based on scan area
    this.cornerRadius = 0.0,
    this.scanLineMargin = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: QRScannerOverlayPainter(
        scanAreaSize: scanAreaSize,
        animationValue: animationValue,
        isDetected: isDetected,
        overlayColor: overlayColor,
        cornerColor: cornerColor,
        lineColor: lineColor,
        cornerThickness: cornerThickness,
        lineThickness: lineThickness,
        cornerLength: cornerLength < 0 ? scanAreaSize / 6 : cornerLength,
        cornerRadius: cornerRadius,
        scanLineMargin: scanLineMargin,
      ),
      child: Container(),
    );
  }
}

class QRScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final double animationValue;
  final bool isDetected;
  final Color overlayColor;
  final Color cornerColor;
  final Color lineColor;
  final double cornerThickness;
  final double lineThickness;
  final double cornerLength;
  final double cornerRadius;
  final double scanLineMargin;

  QRScannerOverlayPainter({
    required this.scanAreaSize,
    required this.animationValue,
    required this.isDetected,
    required this.overlayColor,
    required this.cornerColor,
    required this.lineColor,
    required this.cornerThickness,
    required this.lineThickness,
    required this.cornerLength,
    required this.cornerRadius,
    required this.scanLineMargin,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double screenWidth = size.width;
    final double screenHeight = size.height;
    final double scanAreaLeft = (screenWidth - scanAreaSize) / 2;
    final double scanAreaTop = (screenHeight - scanAreaSize) / 2;
    final double scanAreaRight = scanAreaLeft + scanAreaSize;
    final double scanAreaBottom = scanAreaTop + scanAreaSize;

    // Drawing the shaded overlay outside the scan area
    final Paint overlayPaint = Paint()
      ..color = overlayColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Draw the four rectangles to create the shaded area outside the scanning box
    canvas.drawRect(Rect.fromLTWH(0, 0, screenWidth, scanAreaTop), overlayPaint);
    canvas.drawRect(Rect.fromLTWH(0, scanAreaTop, scanAreaLeft, scanAreaSize), overlayPaint);
    canvas.drawRect(Rect.fromLTWH(scanAreaRight, scanAreaTop, scanAreaLeft, scanAreaSize), overlayPaint);
    canvas.drawRect(Rect.fromLTWH(0, scanAreaBottom, screenWidth, screenHeight - scanAreaBottom), overlayPaint);

    // Draw the corners
    final Paint cornerPaint = Paint()
      ..color = cornerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerThickness;

    final double cornerSize = scanAreaSize / 6;

    // Top left corner
    canvas.drawPath(
        Path()
          ..moveTo(scanAreaLeft, scanAreaTop + cornerSize)
          ..lineTo(scanAreaLeft, scanAreaTop)
          ..lineTo(scanAreaLeft + cornerSize, scanAreaTop),
        cornerPaint);

    // Top right corner
    canvas.drawPath(
        Path()
          ..moveTo(scanAreaRight - cornerSize, scanAreaTop)
          ..lineTo(scanAreaRight, scanAreaTop)
          ..lineTo(scanAreaRight, scanAreaTop + cornerSize),
        cornerPaint);

    // Bottom left corner
    canvas.drawPath(
        Path()
          ..moveTo(scanAreaLeft, scanAreaBottom - cornerSize)
          ..lineTo(scanAreaLeft, scanAreaBottom)
          ..lineTo(scanAreaLeft + cornerSize, scanAreaBottom),
        cornerPaint);

    // Bottom right corner
    canvas.drawPath(
        Path()
          ..moveTo(scanAreaRight - cornerSize, scanAreaBottom)
          ..lineTo(scanAreaRight, scanAreaBottom)
          ..lineTo(scanAreaRight, scanAreaBottom - cornerSize),
        cornerPaint);

    // Draw the scanning line if not detected
    if (!isDetected) {
      final Paint linePaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = lineThickness;

      // Calculate line boundaries with margins
      final double lineMinY = scanAreaTop + scanLineMargin;
      final double lineMaxY = scanAreaBottom - scanLineMargin;
      final double lineRange = lineMaxY - lineMinY;

      // Animation makes the line move up and down within the margins
      final double lineY = lineMinY + (lineRange * animationValue);

      canvas.drawLine(
        Offset(scanAreaLeft + scanLineMargin, lineY),
        Offset(scanAreaRight - scanLineMargin, lineY),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(QRScannerOverlayPainter oldDelegate) {
    return oldDelegate.scanAreaSize != scanAreaSize || oldDelegate.animationValue != animationValue || oldDelegate.isDetected != isDetected || oldDelegate.overlayColor != overlayColor || oldDelegate.cornerColor != cornerColor || oldDelegate.lineColor != lineColor || oldDelegate.cornerThickness != cornerThickness || oldDelegate.lineThickness != lineThickness || oldDelegate.cornerLength != cornerLength || oldDelegate.cornerRadius != cornerRadius || oldDelegate.scanLineMargin != scanLineMargin;
  }
}
