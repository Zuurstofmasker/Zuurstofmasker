import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.chartLines,
    this.leftTitleRenderer,
    this.bottomTitleRenderer,
    this.leftTitles,
    this.bottomTitles,
    this.maxX = 400,
    this.maxY = 100,
    this.minX = 0,
    this.minY = 60,
  });

  final List<ChartLine> chartLines;
  final AxisTitles? leftTitles;
  final AxisTitles? bottomTitles;
  final Widget Function(double, TitleMeta)? leftTitleRenderer;
  final Widget Function(double, TitleMeta)? bottomTitleRenderer;
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;

  // Converting the custom line object in to the LineChartBarData object
  List<LineChartBarData> getLineBarsData() {
    List<LineChartBarData> items = [];
    for (ChartLine line in chartLines) {
      items.add(
        LineChartBarData(
          belowBarData: BarAreaData(
            show: line.hasGradient,
            gradient: line.hasGradient
                ? LinearGradient(
                    colors: [
                      line.color.withOpacity(0.5),
                      line.color.withOpacity(0)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.5, 1.0],
                  )
                : null,
            color: line.color.withAlpha(100),
          ),
          isCurved: true,
          spots: line.chartData,
          color: line.color,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        chartRendererKey: GlobalKey(),
        LineChartData(
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: leftTitles ??
                AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    getTitlesWidget: leftTitleRenderer ?? defaultGetTitle,
                  ),
                ),
            bottomTitles: bottomTitles ??
                AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: bottomTitleRenderer ?? defaultGetTitle,
                  ),
                ),
          ),
          clipData: const FlClipData.all(),
          lineBarsData: getLineBarsData(),
          minY: minY,
          minX: minX,
          maxX: maxX,
          maxY: maxY,
        ),
      ),
    );
  }
}

class ChartLineBase<T> {
  final List<T> chartData;
  final Color color;
  final bool hasGradient;

  ChartLineBase({
    required this.chartData,
    this.color = Colors.black,
    this.hasGradient = true,
  });
}

typedef ChartLine = ChartLineBase<FlSpot>;
typedef TimeChartLine = ChartLineBase<TimeChartData>;

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
  }) {
    setChartData();
  }

  final DateTime? initalTime;
  final double chartSize;
  final bool autoScale;
  final TimeChartLine chartData;
  final List<ChartLine> chartLines;
  final double? minY;
  final double? maxY;
  late List<FlSpot> chartDataLine = [];

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
      maxX: maxX.floorToDouble(),
      minX: minX.floorToDouble(),
      bottomTitleRenderer: (p0, p1) {
        DateTime time = startTime.add(Duration(seconds: p0.toInt()));
        return Text("${time.minute}:${time.second.toString().padLeft(2, '0')}");
      },
      maxY: maxY,
      minY: minY,
    );
  }
}

class TimeChartData {
  final double y;
  final DateTime time;

  TimeChartData({required this.y, required this.time});
}
