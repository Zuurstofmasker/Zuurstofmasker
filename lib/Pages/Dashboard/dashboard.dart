import 'package:flutter/material.dart';
import 'package:zuurstofmasker/nav.dart';

void main() async {
  runApp(const Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

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
