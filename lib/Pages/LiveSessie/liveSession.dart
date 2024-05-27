import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/cameraHelpers.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Models/sessionSerialData.dart';
import 'package:zuurstofmasker/Pages/ConfirmSession/confirmSession.dart';
import 'package:zuurstofmasker/Pages/LiveSessie/lowerLeftPart.dart';
import 'package:zuurstofmasker/Pages/LiveSessie/lowerRightPart.dart';
import 'package:zuurstofmasker/Pages/LiveSessie/upperPart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
import 'package:zuurstofmasker/config.dart';

class LiveSessie extends StatefulWidget {
  const LiveSessie({super.key, required this.sessionData});

  final (SessionSerialData, Session) sessionData;

  @override
  State<LiveSessie> createState() => _LiveSessieState();
}

class _LiveSessieState extends State<LiveSessie> {
  final ValueNotifier<bool> startedSession = ValueNotifier<bool>(false);

  Future onStartSession() async {
    PopupAndLoading.showLoading();

    try {
      startedSession.value = true;
      widget.sessionData.$2.birthTime = DateTime.now();
      await startRecording();
    } catch (e) {
      PopupAndLoading.showError("Opvang starten mislukt");
    }

    PopupAndLoading.endLoading();
  }

  Future onResetSession() async {
    PopupAndLoading.showLoading();

    try {
      widget.sessionData.$2.birthTime = DateTime.now();

      // Clearing all the old irrelevant data
      widget.sessionData.$1.fiO2.clear();
      widget.sessionData.$1.patientFlow.clear();
      widget.sessionData.$1.biasFlow.clear();
      widget.sessionData.$1.stateOutFlow.clear();
      widget.sessionData.$1.seconds.clear();
      widget.sessionData.$1.vte.clear();
      widget.sessionData.$1.vti.clear();

      await stopRecording();
      await startRecording();
    } catch (e) {
      PopupAndLoading.showError("Opvang resetten mislukt");
    }

    PopupAndLoading.endLoading();
  }

  Future onStopSession() async {
    PopupAndLoading.showLoading();

    try {
      startedSession.value = false;
      widget.sessionData.$2.endTime = DateTime.now();
      await updateSession(widget.sessionData.$2);

      widget.sessionData.$1.saveToFile(widget.sessionData.$2.id);
      await stopRecording(
          storeLocation: '$sessionPath${widget.sessionData.$2.id}/video.mp4');

      pushPage(MaterialPageRoute(
          builder: (context) =>
              ConfirmSession(session: widget.sessionData.$2)));
    } catch (e) {
      PopupAndLoading.showError("Opvang stoppen mislukt");
    }

    PopupAndLoading.endLoading();
  }

  @override
  void dispose() {
    stopRecording(
        storeLocation: '$sessionPath${widget.sessionData.$2.id}/video.mp4');
    super.dispose();
  }

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
                  LowerRightPart(
                    startedSession: startedSession,
                    onStartSession: onStartSession,
                    onStopSession: onStopSession,
                    onResetSession: onResetSession,
                    session: widget.sessionData.$2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
