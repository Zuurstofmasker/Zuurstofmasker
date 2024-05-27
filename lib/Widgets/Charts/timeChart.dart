import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/Charts/chart.dart';

// ignore: must_be_immutable
class TimeChart extends StatelessWidget {
  TimeChart({
    super.key,
    required this.chartData,
    this.chartLines = const [],
    this.autoScale = false,
    this.initalTime,
    this.chartSize = 30,
    this.maxY,
    this.minY,
    this.height,
    this.width,
    this.horizontalLinesValues = const [],
    this.onLineTouch,
  }) {
    setChartData();
  }

  late DateTime? initalTime;
  final double chartSize;
  final bool autoScale;
  final TimeChartLine chartData;
  final List<ChartLine> chartLines;
  final double? minY;
  final double? maxY;
  final double? height;
  final double? width;

  late List<FlSpot> chartDataLine = [];
  final List<double> horizontalLinesValues;
  final Function(LineTouchResponse?, double? firstX)? onLineTouch;

  List<HorizontalLine> get horizontalLine =>
      getHorizontalLines(horizontalLinesValues);

  DateTime get startTime => (initalTime ??
      (chartData.chartData.isEmpty
          ? DateTime.now()
          : chartData.chartData.first.time));

  double get maxX {
    if (chartDataLine.isNotEmpty && chartDataLine.last.x > chartSize) {
      return chartDataLine.last.x;
    }
    return chartSize;
  }

  double get minX => autoScale ? 0 : (maxX - chartSize);

  List<FlSpot> setChartData() {
    chartDataLine.clear();
    for (TimeChartData data in chartData.chartData) {
      chartDataLine
          .add(FlSpot(differenceInSeconds(data.time, startTime), data.y));
    }

    return chartDataLine;
  }

  double differenceInSeconds(DateTime startTime, DateTime endTime) {
    return startTime.difference(endTime).inMilliseconds / 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Chart(
      chartLines: [
        ChartLine(chartData: chartDataLine, color: chartData.color),
        ...chartLines
      ],
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
      horizontalLines: horizontalLine,
    );
  }
}

typedef TimeChartLine = ChartLineBase<TimeChartData>;

class TimeChartData {
  final double y;
  final DateTime time;

  TimeChartData({required this.y, required this.time});
}
