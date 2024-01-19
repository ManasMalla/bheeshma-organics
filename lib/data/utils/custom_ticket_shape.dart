import 'package:flutter/material.dart';

class CustomTicketShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5000000, size.height * 0.06781193);
    path_0.cubicTo(
        size.width * 0.5676814,
        size.height * 0.06781193,
        size.width * 0.6225490,
        size.height * 0.03745154,
        size.width * 0.6225490,
        0);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(size.width * 0.6225490, size.height);
    path_0.cubicTo(
        size.width * 0.6225490,
        size.height * 0.9625497,
        size.width * 0.5676814,
        size.height * 0.9321881,
        size.width * 0.5000000,
        size.height * 0.9321881);
    path_0.cubicTo(
        size.width * 0.4323186,
        size.height * 0.9321881,
        size.width * 0.3774510,
        size.height * 0.9625497,
        size.width * 0.3774510,
        size.height);
    path_0.lineTo(0, size.height);
    path_0.lineTo(0, 0);
    path_0.lineTo(size.width * 0.3774510, 0);
    path_0.cubicTo(
        size.width * 0.3774510,
        size.height * 0.03745154,
        size.width * 0.4323186,
        size.height * 0.06781193,
        size.width * 0.5000000,
        size.height * 0.06781193);
    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
