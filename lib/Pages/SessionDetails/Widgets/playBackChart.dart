import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zuurstofmasker/Widgets/Charts/chart.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/config.dart';

class PlayBackChart extends StatelessWidget {
  final double minY;
  final double maxY;
  final dynamic Function(LineTouchResponse?, double?)? onLineTouch;
  final VideoPlayerController? videoController;
  final List<ChartLineBase<TimeChartData>> chartTimeLines;
  final List<double> horizontalLines;
  final String title;
  final Widget Function() bottomWidgetBuilder;
  final List<ChartLine> chartLines;
  final double? width;


  const PlayBackChart({
    super.key,
    required this.minY,
    required this.maxY,
    required this.chartTimeLines,
    required this.videoController,
    required this.title,
    required this.bottomWidgetBuilder,
    this.horizontalLines = const [],
    this.chartLines = const [],
    this.onLineTouch,
    this.width,
  });

  Widget getChart(double? videoPosition) => TimeChart(
        chartTimeLines: chartTimeLines,
        minY: minY,
        maxY: maxY,
        chartSize: 0,
        autoScale: true,
        horizontalLines: horizontalLines,
        onLineTouch: onLineTouch,
        chartLines: chartLines,
        verticalLines: videoPosition == null ? [] : [videoPosition],
        width: width,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: mainPadding,
      height: 265,
      decoration: BoxDecoration(
          border: Border.all(color: greyTextColor), borderRadius: borderRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const PaddingSpacing(),
          Flexible(
            // child: getChart(null),
            child: videoController == null
                ? getChart(null)
                : ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: videoController!,
                    builder: (context, value, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: getChart(
                            value.position.inMilliseconds.toDouble() / 1000,
                          ),
                        ),
                        const PaddingSpacing(),
                        bottomWidgetBuilder(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
