import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final newTextLength = newText.length;

    int selectionIndex = newValue.selection.end;

    // Insert spaces after the first 3 digits and the next 4 digits
    final formattedText = StringBuffer();
    for (int i = 0; i < newTextLength; i++) {
      formattedText.write(newText[i]);
      if (i == 4) {
        formattedText.write(' ');
        selectionIndex++; // Adjust for the inserted space
      }
    }

    return TextEditingValue(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
