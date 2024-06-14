import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Pages/SessionDetails/Parts/Charts/chartsFunctions.dart';
import 'package:zuurstofmasker/Pages/SessionDetails/Widgets/playBackChart.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:video_player/video_player.dart';

class ChartsLowerPart extends StatelessWidget {
  const ChartsLowerPart({
    super.key,
    required this.session,
    required this.callback,
    required this.leakGraphData,
    required this.pressureGraphData,
    required this.flowGraphData,
    required this.tidalVolumeGraphData,
    required this.videoController,
  });
  final void Function(LineTouchResponse?, double?) callback;

  final Session session;
  final VideoPlayerController? videoController;
  final List<TimeChartData> leakGraphData;
  final List<TimeChartData> pressureGraphData;
  final List<TimeChartData> flowGraphData;
  final List<TimeChartData> tidalVolumeGraphData;
  final double sessionLength = 600;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: PlayBackChart(
            minY: 0,
            maxY: 100,
            chartTimeLines: [
              TimeChartLine(
                chartData: leakGraphData,
                color: settings.colors.leak,
              ),
            ],
            videoController: videoController,
            title: "Leak",
            onLineTouch: callback,
            bottomWidgetBuilder: () => Text(
              "${getNearestChartValue(videoController?.value, leakGraphData, session)}%",
              style: liveTitleTextStyle.copyWith(color: settings.colors.leak),
            ),
          ),
        ),
        const PaddingSpacing(
          multiplier: 2,
        ),
        Expanded(
          child: PlayBackChart(
            minY: 0,
            maxY: 40,
            horizontalLines: const [25],
            chartTimeLines: [
              TimeChartLine(
                chartData: pressureGraphData,
                color: settings.colors.pressure,
              ),
            ],
            videoController: videoController,
            title: "Druk",
            onLineTouch: callback,
            bottomWidgetBuilder: () => Text(
              getNearestChartValue(
                  videoController?.value, pressureGraphData, session),
              style: liveTitleTextStyle.copyWith(
                color: settings.colors.pressure,
              ),
            ),
          ),
        ),
        const PaddingSpacing(
          multiplier: 2,
        ),
        Expanded(
          child: PlayBackChart(
            minY: -75,
            maxY: 75,
            horizontalLines: const [0],
            chartTimeLines: [
              TimeChartLine(
                chartData: flowGraphData,
                color: settings.colors.flow,
              )
            ],
            videoController: videoController,
            title: "Flow",
            onLineTouch: callback,
            bottomWidgetBuilder: () => Text(
              getNearestChartValue(
                  videoController?.value, flowGraphData, session),
              style: liveTitleTextStyle.copyWith(color: settings.colors.flow),
            ),
          ),
        ),
        const PaddingSpacing(
          multiplier: 2,
        ),
        Expanded(
          child: PlayBackChart(
            minY: 0,
            maxY: 10,
            horizontalLines: const [4, 8],
            chartTimeLines: [
              TimeChartLine(
                chartData: tidalVolumeGraphData,
                color: settings.colors.tidalVolume,
              ),
            ],
            videoController: videoController,
            title: "Teugvolume",
            onLineTouch: callback,
            bottomWidgetBuilder: () => Text(
              getNearestChartValue(
                  videoController?.value, tidalVolumeGraphData, session),
              style: liveTitleTextStyle.copyWith(
                  color: settings.colors.tidalVolume),
            ),
          ),
        ),
      ],
    );
  }
}
