import 'package:flutter/material.dart';

class SplashECGPainter extends CustomPainter {
  SplashECGPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final centerY = height / 2;

    // We draw a repeating pattern of ECG lines.
    // Let's create a segment that represents one heartbeat and a flat line.
    final segmentWidth = width * 0.8; 
    // Shift the pattern based on progress to make it travel left to right
    final dx = (progress * segmentWidth);

    path.moveTo(-segmentWidth + dx, centerY);
    
    // Draw multiple segments so it continuously travels across the screen
    for (int i = -1; i < 3; i++) {
      final startX = (i * segmentWidth) + dx;
      
      // Flat line before spike
      path.lineTo(startX + segmentWidth * 0.4, centerY);
      
      // Small bump (P wave)
      path.lineTo(startX + segmentWidth * 0.45, centerY - height * 0.2);
      path.lineTo(startX + segmentWidth * 0.5, centerY);
      
      // The Spike (QRS complex)
      path.lineTo(startX + segmentWidth * 0.52, centerY + height * 0.3); // Q
      path.lineTo(startX + segmentWidth * 0.55, centerY - height * 0.8); // R
      path.lineTo(startX + segmentWidth * 0.58, centerY + height * 0.4); // S
      path.lineTo(startX + segmentWidth * 0.6, centerY);
      
      // Small bump (T wave)
      path.lineTo(startX + segmentWidth * 0.7, centerY - height * 0.25);
      path.lineTo(startX + segmentWidth * 0.75, centerY);
      
      // Flat line to end of segment
      path.lineTo(startX + segmentWidth, centerY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SplashECGPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
