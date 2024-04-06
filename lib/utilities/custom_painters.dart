import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class BoundingBoxPainter extends CustomPainter {
  final Face face;

  BoundingBoxPainter({required this.face});

  @override
  void paint(final Canvas canvas, final Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ThicknessSize.large
      ..color = Colors.red;

    final double left = face.boundingBox.left;
    final double top = face.boundingBox.top;
    final double right = face.boundingBox.right;
    final double bottom = face.boundingBox.bottom;

    // Draw the bounding box
    canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;

    // Calculate the center of the box
    final double centerX = (right + left) / 2;
    final double centerY = (top + bottom) / 2;

    // Draw the dot at the center of the box
    canvas.drawCircle(Offset(centerX, centerY), 10.0, dotPaint);
  }

  @override
  bool shouldRepaint(final BoundingBoxPainter oldDelegate) {
    return oldDelegate.face != face;
  }
}

class CenterSquarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const squareSize = 40.0;

    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    final offset =
        Offset((size.width - squareSize) / 2, (size.height - squareSize) / 2);

    canvas.drawRect(
        Rect.fromLTWH(offset.dx, offset.dy, squareSize, squareSize), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
