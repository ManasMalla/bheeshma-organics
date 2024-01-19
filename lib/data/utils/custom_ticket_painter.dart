import 'package:bheeshmaorganics/data/utils/custom_ticket_shape.dart';
import 'package:flutter/material.dart';

class CustomTicketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.black;
    canvas.drawPath(CustomTicketShape().getClip(size), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
