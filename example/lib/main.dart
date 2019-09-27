import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:separated_number_input_formatter/separated_number_input_formatter.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage();

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  static const textFieldTitleStyle = TextStyle(
    color: Colors.black,
    fontSize: 12.0,
  );

  int _digits = 4;
  String _separator = '-';

  TextEditingController _textController;
  TextEditingController _digitsController;
  TextEditingController _separatorController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _digitsController = TextEditingController(text: _digits.toString());
    _separatorController = TextEditingController(text: _separator);
  }

  @override
  void dispose() {
    _separatorController.dispose();
    _digitsController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TextField with the formatter',
              style: textFieldTitleStyle,
            ),
            TextField(
              controller: _textController,
              maxLines: 1,
              keyboardType: TextInputType.number,
              inputFormatters: [
                SeparatedNumberInputFormatter(_digits, separator: _separator),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Expanded(
                  child: Text(
                    'digits',
                    style: textFieldTitleStyle,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    'separator',
                    style: textFieldTitleStyle,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _digitsController,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (digits) {
                      setState(() {
                        _digits = int.parse(digits);
                        _textController.text = '';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: _separatorController,
                    maxLines: 1,
                    inputFormatters: [
                      BlacklistingTextInputFormatter(RegExp(r'\d+')),
                    ],
                    onChanged: (separator) {
                      setState(() {
                        if (separator.isNotEmpty) {
                          _separator = separator;
                        }
                        _textController.text = '';
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
