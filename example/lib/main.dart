import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class ExamplePage extends StatelessWidget {
  const ExamplePage();

  static const textFieldTitleStyle = TextStyle(
    color: Colors.black,
    fontSize: 12.0,
  );

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
              maxLines: 1,
              inputFormatters: [
//                SeparatedNumberInputFormatter(4),
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
                    'separator\n(default is a space)',
                    style: textFieldTitleStyle,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    inputFormatters: [
                      BlacklistingTextInputFormatter(RegExp(r'\d+')),
                    ],
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
