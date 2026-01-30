import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final int rows;
  final int columns;

  GridPainter({required this.rows, required this.columns});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    double cellWidth = size.width / columns;
    double cellHeight = size.height / rows;

    // Draw horizontal lines
    for (int i = 0; i <= rows; i++) {
      canvas.drawLine(
        Offset(0, i * cellHeight),
        Offset(size.width, i * cellHeight),
        paint,
      );
    }

    // Draw vertical lines
    for (int i = 0; i <= columns; i++) {
      canvas.drawLine(
        Offset(i * cellWidth, 0),
        Offset(i * cellWidth, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

