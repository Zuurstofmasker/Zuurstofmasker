import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/Charts/chart.dart';

// ignore: must_be_immutable
class TimeChart extends StatelessWidget {
  TimeChart({
    super.key,
    required this.chartTimeLines,
    this.chartLines = const [],
    this.autoScale = false,
    this.initalTime,
    this.chartSize = 30,
    this.maxY,
    this.minY,
    this.height,
    this.width,
    this.horizontalLines = const [],
    this.verticalLines = const [],
    this.onLineTouch,
  }) {
    setChartData();
  }

  late DateTime? initalTime;
  final double chartSize;
  final bool autoScale;
  final List<TimeChartLine> chartTimeLines;
  final List<ChartLine> chartLines;
  final double? minY;
  final double? maxY;
  final double? height;
  final double? width;

  final List<ChartLine> compiledChartLines = [];
  final List<double> horizontalLines;
  final List<double> verticalLines;
  final Function(LineTouchResponse?, double? firstX)? onLineTouch;

  DateTime get startTime {
    if (initalTime != null) return initalTime!;
    final int minTime = chartTimeLines
        .map<int>((e) =>
            (e.chartData.firstOrNull?.time.millisecondsSinceEpoch ??
                DateTime.now().millisecondsSinceEpoch))
        .reduce(min);

    return DateTime.fromMillisecondsSinceEpoch(minTime);
  }

  double get maxX {
    final double maxValue = compiledChartLines
        .map<double>((e) => (e.chartData.lastOrNull?.x ?? 0.0))
        .reduce(max);
    return maxValue > chartSize ? maxValue : chartSize;
  }

  double get minX => autoScale ? 0 : (maxX - chartSize);

  List<ChartLine> setChartData() {
    compiledChartLines.clear();
    for (TimeChartLine chartTimeLine in chartTimeLines) {
      final List<FlSpot> spots = chartTimeLine.chartData
          .map((e) => FlSpot(differenceInSeconds(e.time, startTime), e.y))
          .toList();

      compiledChartLines.add(ChartLine(
        chartData: spots,
        color: chartTimeLine.color,
      ));
    }

    return chartLines;
  }

  double differenceInSeconds(DateTime startTime, DateTime endTime) {
    return startTime.difference(endTime).inMilliseconds / 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Chart(
      chartLines: [...compiledChartLines, ...chartLines],
      onLineTouch: onLineTouch,
      maxX: maxX.floorToDouble(),
      minX: minX.floorToDouble(),
      bottomTitleRenderer: (p0, p1) {
        DateTime time = startTime.add(Duration(seconds: p0.toInt()));
        return Text("${time.minute}:${time.second.toString().padLeft(2, '0')}");
      },
      bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      maxY: maxY,
      minY: minY,
      width: width,
      height: height,
      horizontalLines: horizontalLines,
      verticalLines: verticalLines,
    );
  }
}

typedef TimeChartLine = ChartLineBase<TimeChartData>;

class TimeChartData {
  final double y;
  final DateTime time;

  TimeChartData({required this.y, required this.time});
}
