import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/cameraHelpers.dart';
import 'package:zuurstofmasker/Helpers/dateAndTimeHelpers.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/Helpers/serialHelpers.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Models/sessionSerialData.dart';
import 'package:zuurstofmasker/Pages/ConfirmSession/confirmSession.dart';
import 'package:zuurstofmasker/Pages/LiveSession/Parts/lowerLeftPart.dart';
import 'package:zuurstofmasker/Pages/LiveSession/Parts/lowerRightPart.dart';
import 'package:zuurstofmasker/Pages/LiveSession/Parts/upperPart.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
import 'package:zuurstofmasker/config.dart';
import 'dart:async';

class LiveSession extends StatefulWidget {
  const LiveSession({
    super.key,
    required this.session,
    required this.serialData,
  });

  final Session session;
  final SessionSerialData serialData;
  @override
  State<LiveSession> createState() => _LiveSessionState();
}

class _LiveSessionState extends State<LiveSession> {
  final ValueNotifier<bool> startedSession = ValueNotifier<bool>(false);
  Timer? periodicSessionDataSave;

  StreamSubscription? timeoutStream;
  bool hasIgnoredTimeout = false;
  bool hasClosedWarning = true;

  late List<Stream<Uint8List>> streams = [
    pressureStream,
    flowStream,
    tidalVolumeStream,
    fiO2Stream,
    spO2Stream,
    pulseStream,
    leakStream
  ];

  final List<StreamSubscription> streamSubscriptions = [];

  void startTimeOut() {
    // Starting the timeout stream
    timeoutStream = streamsHasData(
      streams,
      validator: serialDataValidator,
      interval: const Duration(
        seconds: serialTimeoutInSeconds,
      ),
    ).listen((active) {
      if (active.any((e) => !e) && !hasIgnoredTimeout) onSerialTimeout();
    });
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
    timeListToAdd.add(DateTime.now());
    listToAdd.add(uint8ListToDouble(value));
  }

  Future onStartSession() async {
    PopupAndLoading.showLoading();

    try {
      startedSession.value = true;

      // Subscribing to all the streams
      subscribeToStreams();
      startTimeOut();

      widget.session.birthDateTime = DateTime.now();
      periodicSessionDataSave = Timer(
          const Duration(seconds: saveDateTimeInSeconds),
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

  Future onStopSession([DateTime? endDateTime]) async {
    PopupAndLoading.showLoading();

    try {
      startedSession.value = false;
      widget.session.endDateTime = endDateTime ?? DateTime.now();
      await updateSession(widget.session);

      await widget.serialData.saveToFile(widget.session.id);
      await stopRecording(
          storeLocation: '$sessionPath${widget.session.id}/video.mp4');

      pushAndReplacePage(
        MaterialPageRoute(
          builder: (context) => ConfirmSession(
            session: widget.session,
            serialData: widget.serialData,
          ),
        ),
      );
      disposeStreamsAndTimers();
    } catch (e) {
      PopupAndLoading.showError("Opvang stoppen mislukt");
    }

    PopupAndLoading.endLoading();
  }

  Future onSerialTimeout() async {
    if (!hasClosedWarning) return;
    hasClosedWarning = false;

    final DateTime timeoutTime = DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          title: const Text("Timeout"),
          content: const Text(
              "Een of meerdere meetapparaturen geeft geen meting(en). Is er een patient aan het appararaat gevestigd?"),
          actions: [
            TextButton(
              onPressed: () {
                hasIgnoredTimeout = true;
                Navigator.of(context).pop();
              },
              child: const Text("Negeer"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.serialData.cutDataFrom(timeoutTime);
                onStopSession(timeoutTime);
              },
              child: Text(
                  "Stoppen vanaf ${formatTimeOfDay(TimeOfDay.fromDateTime(timeoutTime))}"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Doorgaan"),
            ),
          ],
        );
      },
    );

    hasClosedWarning = true;
  }

  void disposeStreamsAndTimers() {
    if (periodicSessionDataSave?.isActive ?? false) {
      periodicSessionDataSave!.cancel();
    }

    for (StreamSubscription stream in streamSubscriptions) {
      stream.cancel();
    }

    timeoutStream?.cancel();
  }

  @override
  void dispose() {
    stopRecording(storeLocation: '$sessionPath${widget.session.id}/video.mp4');
    disposeStreamsAndTimers();

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
            ),
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

void saveDateFromStream(
    AsyncSnapshot<Uint8List> snapshot, List<TimeChartData> items) {
  if (snapshot.hasData) {
    items.add(
      TimeChartData(
        y: uint8ListToDouble(snapshot.data!),
        time: DateTime.now(),
      ),
    );
  }
}
