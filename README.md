# separated_number_input_formatter
A TextInputFormatter that allows the insertion of digits separated by specified separator.  
It's very convenient for credit card inputting, price inputting and so on.

## Usage

```dart
// Import package
import 'package:separated_number_input_formatter/separated_number_input_formatter.dart';

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [
        // Use with digits and separator parameters.
        SeparatedNumberInputFormatter(4, separator: '-'),
      ],
    );
  }
}
```

If you want to know more this formatter, let's try my [example](https://github.com/kitoko552/separated_number_input_formatter/tree/master/example) project.
