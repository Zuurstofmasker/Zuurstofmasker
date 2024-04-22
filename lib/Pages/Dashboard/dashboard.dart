import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/sessionDetail.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';

void main() async {
  runApp(const Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Nav(
        child: Column(
      children: [
        Image.asset(
          "assets/HomePageLogo.png",
          height: 500,
          width: 800,
        ),
        TextButton(
            onPressed: () {
              startSession();
            },
            child: Text("Start calibration"))
      ],
    ));
  }

  void startSession() {
    saveSession(SessionDetail(
        nameMother: 'Pieter',
        // birthTime: DateTime.now(),
        id: 1,
        note: "hoi",
        weight: 1300));
  }
}
