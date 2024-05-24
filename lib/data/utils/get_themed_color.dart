import 'package:flutter/material.dart';

Color getThemedColor(BuildContext context, Color lightColor, Color darkColor) {
  return Theme.of(context).brightness == Brightness.dark
      ? darkColor
      : lightColor;
}
