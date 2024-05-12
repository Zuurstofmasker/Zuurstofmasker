import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
// import 'package:zuurstofmasker/Models/sessionDetail.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/form.dart';

TextEditingController nameController = TextEditingController();
TextEditingController noteController = TextEditingController();
TextEditingController weigthController = TextEditingController();

class StartSession extends StatelessWidget {
  const StartSession({super.key});

  void startSession() async {
    saveSession(
      Session(
        nameMother: nameController.text,
        id: await getNewSessionUuid(),
        note: noteController.text,
        birthTime: DateTime.now(),
        weight: int.parse(weigthController.text),
        stateOutFlow: double.parse(stateOutController.text),
        biasFlow: double.parse(biasFlowController.text),
        patientFlow: double.parse(patientFlowController.text),
        fiO2: double.parse(fiO2Controller.text),
        vti: double.parse(vtiController.text),
        vte: double.parse(vteController.text)
      )
        );
  }

  @override
  Widget build(BuildContext context) {
    return Nav(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const PatientForm(),
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
        Button(onTap: startSession, isFullWidth: true, text: "Starten")
      ],
    ));
  }
}
