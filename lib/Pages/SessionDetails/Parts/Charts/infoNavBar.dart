import 'package:flutter/material.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';

class InfoNavBar extends StatelessWidget {
  const InfoNavBar({super.key, required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(children: [
        Button(icon: Icons.tune, onTap: () => {popPage()}, color: primaryColor),
        const PaddingSpacing(
          multiplier: 1,
        ),
        Flexible(
          child: Container(
            decoration: const BoxDecoration(
                color: primaryColor, borderRadius: borderRadius),
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            child: Row(children: [
              Text(session.nameMother),
              const PaddingSpacing(
                multiplier: 1,
              ),
              Text(session.birthDateTime.toString()),
              const PaddingSpacing(
                multiplier: 1,
              ),
              Text("Opvangkamer ${session.roomNumber}"),
              const PaddingSpacing(
                multiplier: 1,
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
