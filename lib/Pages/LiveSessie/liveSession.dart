import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:zuurstofmasker/Helpers/cameraHelpers.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/Helpers/serialHelpers.dart';
import 'package:zuurstofmasker/Helpers/serialMocker.dart';
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
import 'dart:async';

class LiveSessie extends StatefulWidget {
  const LiveSessie({super.key, required this.sessionData});

  final (SessionSerialData, Session) sessionData;

  @override
  State<LiveSessie> createState() => _LiveSessieState();
}

class _LiveSessieState extends State<LiveSessie> {
  final ValueNotifier<bool> startedSession = ValueNotifier<bool>(false);
  Timer? periodicSessionDataSave;
  Timer? serialTimeout;

  final Stream<Uint8List> flowStream =
      SerialPort('').listen(min: 0, max: 40).asBroadcastStream();
  final Stream<Uint8List> patientStream =
      SerialPort('').listen(min: -75, max: 75).asBroadcastStream();
  final Stream<Uint8List> vtiStream =
      SerialPort('').listen(min: 0, max: 10).asBroadcastStream();
  final Stream<Uint8List> fiO2Stream =
      SerialPort('').listen(min: 0, max: 100).asBroadcastStream();
  final Stream<Uint8List> spO2Stream =
      SerialPort('').listen(min: 0, max: 100).asBroadcastStream();
  final Stream<Uint8List> pulseStream =
      SerialPort('').listen(min: 30, max: 225).asBroadcastStream();
  final Stream<Uint8List> leakStream =
      SerialPort('').listen(min: 0, max: 100).asBroadcastStream();

  late List<Stream> streams = [
    flowStream,
    patientStream,
    vtiStream,
    fiO2Stream,
    spO2Stream,
    pulseStream,
    leakStream
  ];

  final List<StreamSubscription> streamSubscriptions = [];

  @override
  void initState() {
    // Subscribing to all the streams
    subscribeToStreams();

    super.initState();
  }

  void subscribeToStreams() {
    SessionSerialData sessionSerialData = widget.sessionData.$1;
    for (int i = 0; i < streams.length; i++) {
      streamSubscriptions.add(
        streams[i].listen(
          (value) => addDataToCSVObject(sessionSerialData.csvData[i],
              sessionSerialData.timestampsLists[i], value),
        ),
      );
    }
  }

  void addDataToCSVObject(
      List<double> listToAdd, List<DateTime> timeListToAdd, Uint8List value) {
    if (startedSession.value) {
      timeListToAdd.add(DateTime.now());
      listToAdd.add(uint8ListToDouble(value));
    }
  }

  Future onStartSession() async {
    PopupAndLoading.showLoading();

    try {
      startedSession.value = true;
      widget.sessionData.$2.birthTime = DateTime.now();
      // serialTimeout = Timer(const Duration(seconds: 5), onSerialTimeout);
      periodicSessionDataSave = Timer(const Duration(seconds: 1),
          () => widget.sessionData.$1.saveToFile(widget.sessionData.$2.id));
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
      SessionSerialData sessionSerial = widget.sessionData.$1;
      for (List<dynamic> list in [
        ...sessionSerial.csvData,
        ...sessionSerial.timestampsLists
      ]) {
        list.clear();
      }

      var (_, video) = await stopRecording();
      if (video?.path != null) {
        await deleteFile(video!.path);
      }
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

      await widget.sessionData.$1.saveToFile(widget.sessionData.$2.id);
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

  Future onSerialTimeout() async {
    PopupAndLoading.showError(
        "Een of meerdere meetapparaturen geeft geen meeting(en). Is er een patient aan het appararaat gevestigd?");
  }

  @override
  void dispose() {
    stopRecording(
        storeLocation: '$sessionPath${widget.sessionData.$2.id}/video.mp4');

    for (StreamSubscription stream in streamSubscriptions) {
      stream.cancel();
    }

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
            UpperPart(
                sessionSerialData: widget.sessionData.$1,
                sessionActive: startedSession,
                flowStream: flowStream,
                patientStream: patientStream,
                vtiStream: vtiStream,
                serialTimeOut: serialTimeout,
                timeoutCallback: onSerialTimeout),
            const PaddingSpacing(
              multiplier: 2,
            ),
            SizedBox(
              height: 360,
              child: Row(
                children: [
                  LowerLeftPart(
                    sessionSerialData: widget.sessionData.$1,
                    sessionActive: startedSession,
                    fiO2Stream: fiO2Stream,
                    spO2Stream: spO2Stream,
                    serialTimeOut: serialTimeout,
                    timeoutCallback: onSerialTimeout,
                  ),
                  const PaddingSpacing(
                    multiplier: 2,
                  ),
                  LowerRightPart(
                    startedSession: startedSession,
                    onStartSession: onStartSession,
                    onStopSession: onStopSession,
                    onResetSession: onResetSession,
                    session: widget.sessionData.$2,
                    pulseStream: pulseStream,
                    leakStream: leakStream,
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
