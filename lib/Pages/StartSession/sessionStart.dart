import 'dart:async';
import 'dart:typed_data';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/cameraHelpers.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/Helpers/serialHelpers.dart';
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
import 'package:zuurstofmasker/Widgets/statusIndicator.dart';

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

  Stream<List<bool>> getStatusStream(Stream<Uint8List> stream) =>
      streamsHasData([stream], validator: serialDataValidator);

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
          SizedBox(
            width: 500,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusIndictor(
                      name: 'Druk',
                      statusStream: getStatusStream(pressureStream),
                    ),
                    const PaddingSpacing(
                      multiplier: 0.25,
                    ),
                    StatusIndictor(
                      name: 'Flow',
                      statusStream: getStatusStream(flowStream),
                    ),
                    const PaddingSpacing(
                      multiplier: 0.25,
                    ),
                    StatusIndictor(
                      name: 'Teugvolume',
                      statusStream: getStatusStream(pressureStream),
                    ),
                    const PaddingSpacing(
                      multiplier: 0.25,
                    ),
                    StatusIndictor(
                      name: 'FiO2',
                      statusStream: getStatusStream(fiO2Stream),
                    ),
                  ],
                ),
                const PaddingSpacing(
                  multiplier: 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusIndictor(
                      statusStream: getStatusStream(spO2Stream),
                      name: "SpO2",
                    ),
                    const PaddingSpacing(
                      multiplier: 0.25,
                    ),
                    StatusIndictor(
                      name: 'Pulse',
                      statusStream: getStatusStream(pulseStream),
                    ),
                    const PaddingSpacing(
                      multiplier: 0.25,
                    ),
                    StatusIndictor(
                      name: 'Leak',
                      statusStream: getStatusStream(leakStream),
                    ),
                    const PaddingSpacing(
                      multiplier: 0.25,
                    ),
                    StatusIndictor(
                      statusStream: streamsHasData<List<CameraDescription>>(
                          [fetchCamerasStream()],
                          validator: (data) => data.isNotEmpty),
                      name: "Camera",
                    ),
                  ],
                )
              ],
            ),
          ),
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
            text: "Starten opname",
          )
        ],
      ),
    ));
  }
}
