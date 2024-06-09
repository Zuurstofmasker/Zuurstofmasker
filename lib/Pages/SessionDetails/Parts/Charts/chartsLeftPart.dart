import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Pages/LiveSession/Functions/chartTreshhold.dart';
import 'package:zuurstofmasker/Pages/SessionDetails/Parts/Charts/chartsFunctions.dart';
import 'package:zuurstofmasker/Pages/SessionDetails/Widgets/playBackChart.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:video_player/video_player.dart';

class ChartsLeftPart extends StatelessWidget {
  const ChartsLeftPart({
    super.key,
    required this.session,
    required this.callback,
    required this.pulseGraphData,
    required this.spO2GraphData,
    required this.fiO2GraphData,
    required this.videoController,
  });
  final void Function(LineTouchResponse?, double?) callback;
  final Session session;
  final VideoPlayerController? videoController;
  final List<TimeChartData> pulseGraphData;
  final List<TimeChartData> spO2GraphData;
  final List<TimeChartData> fiO2GraphData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        PlayBackChart(
          minY: 30,
          maxY: 225,
          chartTimeLines: [
            TimeChartLine(
              chartData: pulseGraphData,
              color: settings.colors.pulse,
            )
          ],
          videoController: videoController,
          title: "Pulse",
          onLineTouch: callback,
          bottomWidgetBuilder: () => Text(
            getNearestChartValue(
                videoController?.value, pulseGraphData, session),
            style: liveTitleTextStyle.copyWith(color: settings.colors.pulse),
          ),
        ),
        const PaddingSpacing(
          multiplier: 2,
        ),
        PlayBackChart(
          minY: 0,
          maxY: 100,
          chartTimeLines: [
            TimeChartLine(
              chartData: spO2GraphData,
              color: settings.colors.spO2,
            ),
            TimeChartLine(
              chartData: fiO2GraphData,
              color: settings.colors.fiO2,
            )
          ],
          chartLines: [generateLowerTreshhold(),generateUpperTreshhold()],
          videoController: videoController,
          title: "Zuurstofsaturatie + fiO2",
          width: 30*60,
          onLineTouch: callback,
          bottomWidgetBuilder: () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "${getNearestChartValue(videoController?.value, fiO2GraphData, session)}%",
                  style:
                      liveTitleTextStyle.copyWith(color: settings.colors.fiO2)),
              Text(
                  "${getNearestChartValue(videoController?.value, spO2GraphData, session)}%",
                  style:
                      liveTitleTextStyle.copyWith(color: settings.colors.spO2)),
            ],
          ),
        ),
      ],
    );
  }
}
