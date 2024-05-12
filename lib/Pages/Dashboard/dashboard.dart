import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Nav(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "Assets/Images/sessionIllustration.svg",
            height: 500,
            width: 800,
          ),
          const SizedBox(height: 50,),
          Button(
            text: "Start calibratie",
            onTap: () async {
              await startSession();
            },
          ),
        ],
      ),
    );
  }

  Future<void> startSession() async {
    saveSession(
      Session(
        nameMother: 'Pieter',
        birthTime: DateTime.now(),
        id: await getNewSessionUuid(),
        note: "hoi",
        weight: 1300,
      ),
    );
  }
}
