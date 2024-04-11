import 'package:flutter/material.dart';
import 'package:zuurstofmasker/nav.dart';

void main() async {
  runApp(const Terugkijken());
}

class Terugkijken extends StatelessWidget {
  const Terugkijken({super.key});

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
