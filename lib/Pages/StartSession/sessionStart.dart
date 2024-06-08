import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/cameraHelpers.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Models/sessionSerialData.dart';
import 'package:zuurstofmasker/Pages/LiveSession/liveSession.dart';
import 'package:zuurstofmasker/Pages/StartSession/Parts/sessionInfoForm.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Pages/StartSession/Parts/sessionCalibrationForm.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
import 'package:zuurstofmasker/Widgets/titles.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Widgets/cameraStatus.dart';

// ignore: must_be_immutable
class StartSession extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController weigthController =
      TextEditingController(text: "3500");
  final TextEditingController babyIdController = TextEditingController();
  final TextEditingController roomNumberController =
      TextEditingController(text: "1");
  final DateTime startTime = DateTime.now();
  final TextEditingController endTimeController = TextEditingController();

  final TextEditingController stateOutController =
      TextEditingController(text: "0");
  final TextEditingController biasFlowController =
      TextEditingController(text: "0");
  final TextEditingController patientFlowController =
      TextEditingController(text: "0");
  final TextEditingController fiO2Controller = TextEditingController(text: "0");
  final TextEditingController vtiController = TextEditingController(text: "0");
  final TextEditingController vteController = TextEditingController(text: "0");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  StartSession({super.key});

  bool cameraStatus = false;
  final ValueNotifier<int> cameraNotifier = ValueNotifier<int>(0);

  Future<(SessionSerialData, Session)> startSession() async {
    String newSessionId = await getNewSessionUuid();

    final Session session = Session(
      nameMother: nameController.text,
      id: newSessionId,
      note: noteController.text,
      birthDateTime: DateTime.now(),
      endDateTime: DateTime.now(),
      babyId: babyIdController.text,
      weight: int.parse(weigthController.text),
      roomNumber: int.parse(roomNumberController.text),
    );
    await createSession(session);

    final SessionSerialData sessionSerialData = SessionSerialData(
        sessionId: newSessionId,
        pressureDateTime: [],
        pressureData: [],
        flowDateTime: [],
        flowData: [],
        tidalVolumeDateTime: [],
        tidalVolumeData: [],
        fiO2DateTime: [],
        fiO2Data: [],
        sp02DateTime: [],
        sp02Data: [],
        pulseDateTime: [],
        pulseData: [],
        leakData: [],
        leakDateTime: []);

    await sessionSerialData.saveToFile(session.id);

    return (sessionSerialData, session);
  }

  @override
  Widget build(BuildContext context) {
    return Nav(
        child: Padding(
      padding: pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: PatientForm(
                    stateOutController: stateOutController,
                    biasFlowController: biasFlowController,
                    patientFlowController: patientFlowController,
                    fiO2Controller: fiO2Controller,
                    vtiController: vtiController,
                    vteController: vteController,
                  ),
                ),
                const PaddingSpacing(
                  multiplier: 2,
                ),
                Flexible(
                  child: SessionInfoForm.start(
                    nameController: nameController,
                    noteController: noteController,
                    weigthController: weigthController,
                    babyIdController: babyIdController,
                    roomNumberController: roomNumberController,
                  ),
                ),
              ],
            ),
          ),
          const PaddingSpacing(
            multiplier: 2,
          ),
          const PageTitle(title: "Status"),
          const PaddingSpacing(),
          ValueListenableBuilder(
              valueListenable: cameraNotifier,
              builder: (context, value, child) {
                Timer(
                  const Duration(seconds: 1),
                  () {
                    cameraNotifier.value++;
                  },
                );
                return FutureBuilder(
                    future: fetchCameras(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("error");
                      } else if (snapshot.hasData) {
                        cameraStatus = snapshot.data!.isNotEmpty;
                      }
                      return CameraStatus(status: cameraStatus);
                    });
              }),
          const PaddingSpacing(
            multiplier: 2,
          ),
          Button(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                PopupAndLoading.showLoading();
                await startSession().then((value) {
                  pushPage(
                    MaterialPageRoute(
                      builder: (context) => LiveSession(
                        serialData: value.$1,
                        session: value.$2,
                      ),
                    ),
                  );
                }).catchError((error) {
                  PopupAndLoading.showError("Data oplsaan mislukt");
                });
                PopupAndLoading.endLoading();
              }
            },
            text: "Starten",
          )
        ],
      ),
    ));
  }
}
