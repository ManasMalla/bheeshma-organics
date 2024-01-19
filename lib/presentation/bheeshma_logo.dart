import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BheeshmaOrganicsLogo extends StatelessWidget {
  final double height;
  final Color? color;
  const BheeshmaOrganicsLogo({
    super.key,
    this.height = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/logo.svg',
      height: height,
      color: color,
    );
  }
}
