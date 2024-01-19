import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

SnackBar BheeshmaSnackbar(
    {required title, required message, required contentType}) {
  return SnackBar(
    elevation: 0,
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
      imagePath: 'assets/images/character-two-upright.svg',
    ),
  );
}
