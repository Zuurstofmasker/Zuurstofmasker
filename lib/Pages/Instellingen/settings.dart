import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';

void main() async {
  runApp(const Settings());
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Nav(
      child: const Text(
        'test page',
      ),
    );
  }
}
