import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Pages/LiveSessie/lowerLeftPart.dart';
import 'package:zuurstofmasker/Pages/LiveSessie/lowerRightPart.dart';
import 'package:zuurstofmasker/Pages/LiveSessie/upperPart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/config.dart';

class LiveSessie extends StatelessWidget {
  const LiveSessie({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UpperPart(),
            const PaddingSpacing(
              multiplier: 2,
            ),
            SizedBox(
              height: 360,
              child: Row(
                children: [
                  LowerLeftPart(),
                  const PaddingSpacing(
                    multiplier: 2,
                  ),
                  LowerRightPart()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
