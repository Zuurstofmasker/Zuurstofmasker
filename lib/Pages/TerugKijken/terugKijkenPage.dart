import 'dart:collection';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Helpers/serialHelpers.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/chartsLeftPart.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/videoPlayer.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/chartsLowerPart.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/terugKijkenNavBar.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:video_player/video_player.dart';

class TerugKijken extends StatelessWidget {
  TerugKijken({super.key, required this.session}) {
    loadVideoPlayer();
    loadSessionData();
  }
  final Session session;

  VideoPlayerController? controller;
  var currentTime = 0;
  List<TimeChartData> stateOutFlow = []; //leak
  List<TimeChartData> biasFlow = []; // druk
  List<TimeChartData> patientFlow = []; // flow
  List<TimeChartData> fiO2 = []; //fi02
  List<TimeChartData> vti = []; //terug volume
  List<TimeChartData> vte = []; // pulse
  List<TimeChartData> spO2 = []; // sp02

  void loadSessionData() {
    var path = "$sessionPath${session.id}\\recordedData.csv";

    var data = csvFromFileSync(path);
    data.removeAt(0);
    var i = 0;
    for (var meetwardes in data) {
      stateOutFlow.add(makeTimeCartData(meetwardes[1], i));
      biasFlow.add(makeTimeCartData(meetwardes[3], i));
      patientFlow.add(makeTimeCartData(meetwardes[5], i));
      fiO2.add(makeTimeCartData(meetwardes[7], i));
      vti.add(makeTimeCartData(meetwardes[9], i));
      vte.add(makeTimeCartData(meetwardes[11], i));
      spO2.add(makeTimeCartData(meetwardes[12], i));
      i++;
    }
  }

  TimeChartData makeTimeCartData(dynamic value, int i) {
    return TimeChartData(
        y: valueConverter(value),
        time: DateTime.now().add(Duration(seconds: i)));
  }

  double valueConverter(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String && value.isNotEmpty) {
      return double.tryParse(value) ??
          0.0; // 0.0 as a default value if parsing fails
    } else {
      return 0.0; // Default value for unsupported types or empty strings
    }
  }

  void loadVideoPlayer() {
    controller?.dispose();
    var path = "$sessionPath${session.id}\\video.mp4";
    if (File(path).existsSync()) {
      controller = VideoPlayerController.file(File(path));
    }
  }

  void chartTouche(LineTouchResponse? lineTouchResponse, double? value) {
    if (controller == null || value == null) {
      return;
    }
    int timeMs = value!.toInt() * 1000;
    if (controller!.value.duration.inMilliseconds > timeMs) {
      controller?.seekTo(Duration(milliseconds: timeMs));
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TerugKijkenNavBar(session: session),
            const PaddingSpacing(
              multiplier: 1,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 600,
                  width: 442,
                  child: ChartsLeftPart(
                    session: session,
                    callback: chartTouche,
                    runTime: controller?.value.position.inSeconds ?? 0,
                    duration: controller?.value.duration.inSeconds ?? 0,
                    pulseGraphData: vte,
                    spO2GraphData: spO2,
                  ),
                ),
                const PaddingSpacing(
                  multiplier: 2,
                ),
                VideoPlr(
                  session: session,
                  controller: controller,
                )
              ],
            ),
            const PaddingSpacing(
              multiplier: 2,
            ),
            SizedBox(
              height: 300,
              width: 1900,
              child: ChartsLowerPart(
                session: session,
                callback: chartTouche,
                runTime: controller?.value.position.inSeconds ?? 0,
                duration: controller?.value.duration.inSeconds ?? 0,
                flowGraphData: patientFlow,
                leakGraphData: stateOutFlow,
                pressureGraphData: biasFlow,
                tidalVolumeGraphData: vti,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
