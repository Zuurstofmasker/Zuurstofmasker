import 'package:flutter/material.dart';
import 'package:zuurstofmasker/nav.dart';

void main() async {
  runApp(const TestPage());
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Nav(
      title: const Text(
        "TestPage",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      child: Container(),
    );
  }
}
