import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.chartData,
    required this.color,
    this.leftTitleRenderer,
    this.bottomTitleRenderer,
    this.leftTitles,
    this.bottomTitles,
    this.maxX = 400,
    this.maxY = 100,
    this.minX = 0,
    this.minY = 60,
  });

  final List<FlSpot> chartData;
  final AxisTitles? leftTitles;
  final AxisTitles? bottomTitles;
  final Widget Function(double, TitleMeta)? leftTitleRenderer;
  final Widget Function(double, TitleMeta)? bottomTitleRenderer;
  final Color color;
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;

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
          lineBarsData: [
            LineChartBarData(
              belowBarData: BarAreaData(
                show: true,
                color: color.withAlpha(100),
              ),
              isCurved: true,
              spots: chartData,
              color: color,
            )
          ],
          minY: minY,
          minX: minX,
          maxX: maxX,
          maxY: maxY,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TimeChart extends StatelessWidget {
  TimeChart({
    super.key,
    required this.chartData,
    required this.color,
    this.startTime,
    this.endTime,
    this.maxY,
    this.minY,
  }) {
    startTime ??= DateTime.now().subtract(const Duration(seconds: 30));
    endTime ??= DateTime.now();
  }

  late DateTime? startTime;
  late DateTime? endTime;
  final List<TimeChartData> chartData;
  final Color color;
  final double? minY;
  final double? maxY;

  List<FlSpot> getChartData() {
    List<FlSpot> items = [];
    for (TimeChartData data in chartData) {
      items.add(
        FlSpot(differenceToSecdonds(data.time, startTime!).toDouble(), data.y),
      );
    }
    return items;
  }

  double differenceToSecdonds(DateTime startTime, DateTime endTime) {
    return startTime.difference(endTime).inMilliseconds / 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Chart(
      chartData: getChartData(),
      color: color,
      maxX: differenceToSecdonds(endTime!, startTime!).toDouble(),
      bottomTitleRenderer: (p0, p1) {
        DateTime time = startTime!.add(Duration(seconds: p0.toInt()));
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
