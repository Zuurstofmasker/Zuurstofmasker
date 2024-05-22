import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Models/sessionSerialData.dart';
import 'package:zuurstofmasker/Pages/LiveSessie/liveSessie.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/form.dart';

TextEditingController nameController = TextEditingController();
TextEditingController noteController = TextEditingController();
TextEditingController weigthController = TextEditingController();
SessionSerialData? sessionData;

class StartSession extends StatelessWidget {
  const StartSession({super.key});

  void startSession() async {
    String newSessionId = await getNewSessionUuid();
    saveSession(
      Session(
        nameMother: nameController.text,
        id: newSessionId,
        note: noteController.text,
        birthTime: DateTime.now(),
        weight: int.parse(weigthController.text)
      )
    );
    
    sessionData = SessionSerialData(
      sessionId: newSessionId,
      seconds: List<double>.generate(1, (index) => 0, growable: true),
      stateOutFlow: List<double>.generate(1, (index) => double.parse(stateOutController.text), growable: true),
      biasFlow: List<double>.generate(1, (index) => double.parse(biasFlowController.text)),
      patientFlow: List<double>.generate(1, (index) => double.parse(patientFlowController.text), growable: true),
      fiO2: List<double>.generate(1, (index) => double.parse(fiO2Controller.text), growable: true),
      vti: List<double>.generate(1, (index) => double.parse(vtiController.text), growable: true),
      vte: List<double>.generate(1, (index) => double.parse(vteController.text), growable: true)
      );

    updateRecordedData(sessionData!);
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
          isRequired: true,
        ),
        Button(onTap:() {
              startSession;
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const LiveSessie()));
                }, text: "Starten",)
      ],
    ));
  }
}
