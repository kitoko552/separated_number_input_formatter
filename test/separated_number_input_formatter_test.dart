import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:separated_number_input_formatter/separated_number_input_formatter.dart';

void main() {
  TextEditingValue output;
  final formatter = SeparatedNumberInputFormatter(4);

  group('forbits non-number input', () {
    test('inputs first', () {
      output = formatter.formatEditUpdate(
        TextEditingValue(
          text: '',
          selection: const TextSelection.collapsed(offset: 0),
        ),
        TextEditingValue(
          text: 'a',
          selection: const TextSelection.collapsed(offset: 1),
        ),
      );
      expect(output.text, '');
      expect(output.selection, const TextSelection.collapsed(offset: 0));
    });

    test('append', () {
      output = formatter.formatEditUpdate(
        TextEditingValue(
          text: '123',
          selection: const TextSelection.collapsed(offset: 3),
        ),
        TextEditingValue(
          text: '123A',
          selection: const TextSelection.collapsed(offset: 4),
        ),
      );
      expect(output.text, '123');
      expect(output.selection, const TextSelection.collapsed(offset: 3));
    });

    test('prepend', () {
      output = formatter.formatEditUpdate(
        TextEditingValue(
          text: '1234 567',
          selection: const TextSelection.collapsed(offset: 0),
        ),
        TextEditingValue(
          text: '+1234 567',
          selection: const TextSelection.collapsed(offset: 1),
        ),
      );
      expect(output.text, '1234 567');
      expect(output.selection, const TextSelection.collapsed(offset: 0));
    });

    test('prepend', () {
      output = formatter.formatEditUpdate(
        TextEditingValue(
          text: '1234 5678 9',
          selection: const TextSelection.collapsed(offset: 7),
        ),
        TextEditingValue(
          text: '1234 56*78 9',
          selection: const TextSelection.collapsed(offset: 8),
        ),
      );
      expect(output.text, '1234 5678 9');
      expect(output.selection, const TextSelection.collapsed(offset: 7));
    });
  });

  group('inputs', () {
    test('inputs first number correctly', () {
      output = formatter.formatEditUpdate(
        TextEditingValue(
          text: '',
          selection: const TextSelection.collapsed(offset: 0),
        ),
        TextEditingValue(
          text: '0',
          selection: const TextSelection.collapsed(offset: 1),
        ),
      );
      expect(output.text, '0');
      expect(output.selection, const TextSelection.collapsed(offset: 1));
    });

    test('inserts a number', () {
      output = formatter.formatEditUpdate(
        TextEditingValue(
          text: '1234',
          selection: const TextSelection.collapsed(offset: 2),
        ),
        TextEditingValue(
          text: '12034',
          selection: const TextSelection.collapsed(offset: 3),
        ),
      );
      expect(output.text, '1203 4');
      expect(output.selection, const TextSelection.collapsed(offset: 3));
    });

    test('inserts a number to before a separator', () {
      output = formatter.formatEditUpdate(
        TextEditingValue(
          text: '123',
          selection: const TextSelection.collapsed(offset: 3),
        ),
        TextEditingValue(
          text: '1234',
          selection: const TextSelection.collapsed(offset: 4),
        ),
      );
      expect(output.text, '1234');
      expect(output.selection, const TextSelection.collapsed(offset: 4));
    });

    test(
      '(digitsの倍数 + 1)桁目を入力した時は空白の次に数字が入力されるためその先にキャレットを移動',
      () {
        output = formatter.formatEditUpdate(
          TextEditingValue(
            text: '1234',
            selection: const TextSelection.collapsed(offset: 4),
          ),
          TextEditingValue(
            text: '12340',
            selection: const TextSelection.collapsed(offset: 5),
          ),
        );
        expect(output.text, '1234 0');
        expect(output.selection, const TextSelection.collapsed(offset: 6));

        output = formatter.formatEditUpdate(
          TextEditingValue(
            text: '1234 5678',
            selection: const TextSelection.collapsed(offset: 4),
          ),
          TextEditingValue(
            text: '12340 5678',
            selection: const TextSelection.collapsed(offset: 5),
          ),
        );
        expect(output.text, '1234 0567 8');
        expect(output.selection, const TextSelection.collapsed(offset: 6));
      },
    );
  });

  group('deltes', () {
    test('deltes last number', () {
      output = formatter.formatEditUpdate(
        TextEditingValue(
          text: '0',
          selection: const TextSelection.collapsed(offset: 1),
        ),
        TextEditingValue(
          text: '',
          selection: const TextSelection.collapsed(offset: 0),
        ),
      );
      expect(output.text, '');
      expect(output.selection, const TextSelection.collapsed(offset: 0));
    });

    test('deltes a number from numbers', () {
      output = formatter.formatEditUpdate(
        TextEditingValue(
          text: '1234 5',
          selection: const TextSelection.collapsed(offset: 2),
        ),
        TextEditingValue(
          text: '134 5',
          selection: const TextSelection.collapsed(offset: 1),
        ),
      );
      expect(output.text, '1345');
      expect(output.selection, const TextSelection.collapsed(offset: 1));

      output = formatter.formatEditUpdate(
        TextEditingValue(
          text: '1234 5678 9',
          selection: const TextSelection.collapsed(offset: 7),
        ),
        TextEditingValue(
          text: '1234 578 9',
          selection: const TextSelection.collapsed(offset: 6),
        ),
      );
      expect(output.text, '1234 5789');
      expect(output.selection, const TextSelection.collapsed(offset: 6));
    });

    test('deletes a space', () {
      output = formatter.formatEditUpdate(
        TextEditingValue(
          text: '1234 5',
          selection: const TextSelection.collapsed(offset: 5),
        ),
        TextEditingValue(
          text: '1234 5',
          selection: const TextSelection.collapsed(offset: 4),
        ),
      );
      expect(output.text, '1234 5');
      expect(output.selection, const TextSelection.collapsed(offset: 4));
    });

    test(
      '(digitsの倍数 + 1)桁目を削除した時は直前に空白があるため空白の直前にキャレットを移動',
      () {
        output = formatter.formatEditUpdate(
          TextEditingValue(
            text: '1234 5',
            selection: const TextSelection.collapsed(offset: 6),
          ),
          TextEditingValue(
            text: '1234 ',
            selection: const TextSelection.collapsed(offset: 5),
          ),
        );
        expect(output.text, '1234');
        expect(output.selection, const TextSelection.collapsed(offset: 4));

        output = formatter.formatEditUpdate(
          TextEditingValue(
            text: '1234 5678 9',
            selection: const TextSelection.collapsed(offset: 6),
          ),
          TextEditingValue(
            text: '1234 678 9',
            selection: const TextSelection.collapsed(offset: 5),
          ),
        );
        expect(output.text, '1234 6789');
        expect(output.selection, const TextSelection.collapsed(offset: 4));
      },
    );
  });

  test('Android errors', () {
    output = formatter.formatEditUpdate(
      TextEditingValue(
        text: '1234 5',
        selection: const TextSelection.collapsed(offset: 6),
      ),
      TextEditingValue(
        text: '12345',
        selection: const TextSelection.collapsed(offset: 5),
      ),
    );
    expect(output.text, '1234 5');
    expect(output.selection, const TextSelection.collapsed(offset: 6));

    output = formatter.formatEditUpdate(
      TextEditingValue(
        text: '1234',
        selection: const TextSelection.collapsed(offset: 4),
      ),
      TextEditingValue(
        text: '1234 ',
        selection: const TextSelection.collapsed(offset: 5),
      ),
    );
    expect(output.text, '1234');
    expect(output.selection, const TextSelection.collapsed(offset: 4));
  });
}
