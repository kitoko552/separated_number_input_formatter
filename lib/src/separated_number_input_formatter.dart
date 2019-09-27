import 'dart:math';

import 'package:flutter/services.dart';

/// A [TextInputFormatter] that allows the insertion of digits separated each
/// number of [digits] by [separator].
///
/// This formatter has an ability to allow only the insertion of digits.
/// So you don't need to add [WhitelistingTextInputFormatter.digitsOnly] to
/// inputFormatters of your text field.
class SeparatedNumberInputFormatter extends TextInputFormatter {
  SeparatedNumberInputFormatter(
    this.digits, {
    this.separator = ' ',
  })  : assert(digits != null),
        assert(separator != null),
        assert(separator.isNotEmpty);

  final int digits;

  /// Default is a space(' ').
  final String separator;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final trimmedNewText = newValue.text.replaceAll(separator, '');
    if (trimmedNewText.contains(RegExp(r'\D'))) {
      return oldValue;
    }

    String manipulated = '';
    for (int i = 0; i < trimmedNewText.length; i++) {
      final char = String.fromCharCode(trimmedNewText.runes.toList()[i]);
      if ((i + 1) % digits == 0) {
        manipulated += char + separator;
      } else {
        manipulated += char;
      }
    }
    manipulated = manipulated.trimRight();

    final trimmedOldText = oldValue.text.replaceAll(separator, '');
    int selectionOffset = newValue.selection.baseOffset;
    if (trimmedNewText.length > trimmedOldText.length) {
      // Inputting
      // When an user inputs a number to (a multiple of [digits] + 1),
      // the number will be input after a separator by this formatter.
      // So the cursor should be moved after it.

      final previousChar = manipulated.substring(
        max(newValue.selection.baseOffset - 1, 0),
        min(newValue.selection.baseOffset, manipulated.length),
      );
      if (previousChar == separator) {
        selectionOffset += 1;
      }
    } else if (trimmedNewText.length < trimmedOldText.length) {
      // Deleting
      // When an user deletes a number of (a multiple of [digits] + 1),
      // the cursor will be moved after a separator.
      // So the cursor should be moved before a separator to easy to next deleting or inputting

      final previousChar = manipulated.substring(
        max(newValue.selection.baseOffset - 1, 0),
        min(newValue.selection.baseOffset, manipulated.length),
      );
      if (previousChar == separator) {
        selectionOffset -= 1;
      }
      selectionOffset = min(selectionOffset, manipulated.length);
    } else {
      // Deleting a separator or an Android error occurred

      final nextChar = manipulated.substring(
        min(newValue.selection.baseOffset, manipulated.length),
        min(newValue.selection.baseOffset + 1, manipulated.length),
      );
      if (nextChar != separator) {
        // There is an issue that reverts back to previous value only in Android.
        // In that case, use oldValue.
        selectionOffset = oldValue.selection.baseOffset;
      }
    }

    return newValue.copyWith(
      text: manipulated,
      selection: newValue.selection.copyWith(
        baseOffset: selectionOffset,
        extentOffset: selectionOffset,
      ),
    );
  }
}
