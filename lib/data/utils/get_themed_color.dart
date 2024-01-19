import 'package:flutter/material.dart';

getThemedColor(BuildContext context, Color lightColor, Color darkColor) {
  return Theme.of(context).brightness == Brightness.dark
      ? darkColor
      : lightColor;
}
