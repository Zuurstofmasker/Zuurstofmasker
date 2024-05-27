import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/Pages/StartSession/sessionStart.dart';
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
          const SizedBox(
            height: 50,
          ),
          Button(
            text: "Start calibratie",
            onTap: () => pushPage(
                MaterialPageRoute(builder: (context) => StartSession())),
          ),
        ],
      ),
    );
  }
}
