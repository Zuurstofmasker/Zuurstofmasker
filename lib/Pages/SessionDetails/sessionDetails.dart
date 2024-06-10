import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Models/sessionSerialData.dart';
import 'package:zuurstofmasker/Pages/SessionDetails/Parts/VideoPlayer/videoPlayer.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Pages/SessionDetails/Parts/Charts/chartsLeftPart.dart';
import 'package:zuurstofmasker/Pages/SessionDetails/Parts/Charts/chartsLowerPart.dart';
import 'package:zuurstofmasker/Pages/SessionDetails/Parts/Charts/infoNavBar.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class SessionDetails extends StatelessWidget {
  SessionDetails({super.key, required this.session, required this.serialData}) {
    loadVideoPlayer();
  }
  final Session session;
  final SessionSerialData serialData;

  VideoPlayerController? controller;
  late List<TimeChartData> pressureData = getTimeChartDataList(
      serialData.pressureDateTime, serialData.pressureData); //pressure
  late List<TimeChartData> flowData = getTimeChartDataList(
      serialData.flowDateTime, serialData.flowData); // flow
  late List<TimeChartData> tidalVolumeData = getTimeChartDataList(
      serialData.tidalVolumeDateTime,
      serialData.tidalVolumeData); // tidalVolume
  late List<TimeChartData> fiO2Data =
      getTimeChartDataList(serialData.fiO2DateTime, serialData.fiO2Data); //fi02
  late List<TimeChartData> spO2Data =
      getTimeChartDataList(serialData.sp02DateTime, serialData.sp02Data); //spo2
  late List<TimeChartData> pulseData = getTimeChartDataList(
      serialData.pulseDateTime, serialData.pulseData); // pulse
  late List<TimeChartData> leakData = getTimeChartDataList(
      serialData.leakDateTime, serialData.leakData); // leak

  List<TimeChartData> getTimeChartDataList(
          List<DateTime> dates, List<double> values) =>
      [
        for (int i = 0; i < dates.length; i++)
          TimeChartData(y: values[i], time: dates[i])
      ];

  void loadVideoPlayer() {
    controller?.dispose();
    var path = "$sessionPath${session.id}\\video.mp4";
    if (File(path).existsSync()) {
      controller = VideoPlayerController.file(File(path));
    }
  }

  void chartTouch(LineTouchResponse? lineTouchResponse, double? value) {
    if (controller == null || value == null) {
      return;
    }
    int timeMs = value.toInt() * 1000;
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
            InfoNavBar(session: session),
            const PaddingSpacing(
              multiplier: 1,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    child: ChartsLeftPart(
                      session: session,
                      callback: chartTouch,
                      pulseGraphData: pulseData,
                      spO2GraphData: spO2Data,
                      fiO2GraphData: fiO2Data,
                      videoController: controller,
                    ),
                  ),
                ),
                const PaddingSpacing(
                  multiplier: 3,
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    child: VideoPlr(
                      session: session,
                      controller: controller,
                    ),
                  ),
                ),
                const PaddingSpacing(
                  multiplier: 3,
                ),
              ],
            ),
            const PaddingSpacing(),
            SizedBox(
              height: 300,
              child: ChartsLowerPart(
                videoController: controller,
                session: session,
                callback: chartTouch,
                flowGraphData: flowData,
                leakGraphData: leakData,
                pressureGraphData: pressureData,
                tidalVolumeGraphData: tidalVolumeData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
