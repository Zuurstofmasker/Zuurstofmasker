import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/sessionDetail.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';

TextEditingController nameController = TextEditingController();
TextEditingController noteController = TextEditingController();
TextEditingController weigthController = TextEditingController();

class StartSession extends StatelessWidget {
  const StartSession({super.key});

  void saveSessionData() {
    saveSession(SessionDetail(
        nameMother: nameController.text,
        // birthTime: DateTime.now(),
        id: 1,
        note: noteController.text,
        weight: int.tryParse(weigthController.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Nav(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InputField(
          controller: nameController,
          hintText: "Moeder naam",
        ),
        InputField(
          controller: noteController,
          hintText: "Notitie",
        ),
        InputField(
          controller: weigthController,
          hintText: "Gewicht",
          isInt: true,
        ),
        Button(onTap: saveSessionData, isFullWidth: true, text: "Starten")
      ],
    ));
  }
}
