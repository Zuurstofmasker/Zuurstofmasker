import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Pages/StartSessie/startsession.dart';
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StartSession()),
              );
            },
            child: const Text("Start calibration"))
      ],
    ));
  }
}
