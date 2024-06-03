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
  const LiveSessie({
    super.key,
    required this.session,
    required this.serialData,
  });

  final Session session;
  final SessionSerialData serialData;
  @override
  State<LiveSessie> createState() => _LiveSessieState();
}

class _LiveSessieState extends State<LiveSessie> {
  final ValueNotifier<bool> startedSession = ValueNotifier<bool>(false);
  Timer? periodicSessionDataSave;
  Timer? serialTimeout;

  final Stream<Uint8List> pressureStream =
      SerialPort('').listen(min: 0, max: 40).asBroadcastStream();
  final Stream<Uint8List> flowStream =
      SerialPort('').listen(min: -75, max: 75).asBroadcastStream();
  final Stream<Uint8List> tidalVolumeStream =
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
    pressureStream,
    flowStream,
    tidalVolumeStream,
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
    SessionSerialData sessionSerialData = widget.serialData;
    for (int i = 0; i < streams.length; i++) {
      streamSubscriptions.add(
        streams[i].listen((value) {
          addDataToCSVObject(sessionSerialData.valueLists[i],
              sessionSerialData.timestampsLists[i], value);
        }),
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
      widget.session.birthDateTime = DateTime.now();
      // serialTimeout = Timer(const Duration(seconds: 5), onSerialTimeout);
      periodicSessionDataSave = Timer(const Duration(seconds: 1),
          () => widget.serialData.saveToFile(widget.session.id));
      await startRecording();
    } catch (e) {
      PopupAndLoading.showError("Opvang starten mislukt");
    }

    PopupAndLoading.endLoading();
  }

  Future onResetSession() async {
    PopupAndLoading.showLoading();

    try {
      widget.session.birthDateTime = DateTime.now();

      // Clearing all the old irrelevant data
      SessionSerialData sessionSerial = widget.serialData;
      for (List<dynamic> list in [
        ...sessionSerial.valueLists,
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
      widget.session.endDateTime = DateTime.now();
      await updateSession(widget.session);

      await widget.serialData.saveToFile(widget.session.id);
      await stopRecording(
          storeLocation: '$sessionPath${widget.session.id}/video.mp4');

      pushPage(
        MaterialPageRoute(
          builder: (context) => ConfirmSession(
            session: widget.session,
            serialData: widget.serialData,
          ),
        ),
      );
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
    stopRecording(storeLocation: '$sessionPath${widget.session.id}/video.mp4');

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
                sessionSerialData: widget.serialData,
                sessionActive: startedSession,
                pressureStream: pressureStream,
                flowStream: flowStream,
                tidalVolumeStream: tidalVolumeStream,
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
                    sessionSerialData: widget.serialData,
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
                    session: widget.session,
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
