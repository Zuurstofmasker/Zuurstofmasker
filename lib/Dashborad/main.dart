import 'package:flutter/material.dart';
import 'package:zuurstofmasker/nav.dart';

void main() async {
  runApp(const Dashborad());
}

class Dashborad extends StatelessWidget {
  const Dashborad({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Nav(
      title: const Text(
        "Maak een keuze",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      child: Container(),
    );
  }
}
