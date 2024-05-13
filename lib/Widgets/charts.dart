import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart(
      {super.key,
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
      this.height = 200,
      this.width,
      this.horizontalLines,
      this.getHorizontalLines2});

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
  final double? height;
  final double? width;
  final List<double>? horizontalLines;
  final List<HorizontalLine>? getHorizontalLines2;

  List<HorizontalLine> getHorizontalLines() {
    var allitems = List<HorizontalLine>.empty(growable: true);

    var items = horizontalLines
        ?.map((e) => HorizontalLine(
              y: 100,
              color: Color.fromARGB(97, 0, 0, 0),
              strokeWidth: 1,
            ))
        .toList();
    if (items != null) {
      allitems.addAll(items);
    }
    return allitems;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: LineChart(
        chartRendererKey: GlobalKey(),
        LineChartData(
            gridData: const FlGridData(show: false),
            extraLinesData: ExtraLinesData(
              horizontalLines: getHorizontalLines2 ?? [],
            ),
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
                dotData: const FlDotData(
                  show: false,
                ),
                isCurved: true,
                spots: chartData,
                color: color,
              ),
            ],
            minY: minY,
            minX: minX,
            maxX: maxX,
            maxY: maxY,
            baselineY: 100),
      ),
    );
  }
}

// ignore: must_be_immutable
class TimeChart extends StatelessWidget {
  TimeChart(
      {super.key,
      required this.chartData,
      required this.color,
      this.startTime,
      this.endTime,
      this.maxY,
      this.minY,
      this.height,
      this.horizontalLines}) {
    startTime ??= DateTime.now().subtract(const Duration(seconds: 30));
    endTime ??= DateTime.now();

    List<HorizontalLine> getHorizontalLines() {
      var allitems = List<HorizontalLine>.empty(growable: true);

      var items = horizontalLines
          ?.map((e) => HorizontalLine(
                y: e,
                color: Color.fromARGB(97, 0, 0, 0),
                strokeWidth: 1,
              ))
          .toList();
      if (items != null) {
        allitems.addAll(items);
      }
      return allitems;
    }

    HorizontalLine2 = getHorizontalLines();
  }

  late DateTime? startTime;
  late DateTime? endTime;
  final List<TimeChartData> chartData;
  final Color color;
  final double? minY;
  final double? maxY;
  final double? height;
  final List<double>? horizontalLines;
  List<HorizontalLine>? HorizontalLine2;
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
      bottomTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      maxY: maxY,
      minY: minY,
      height: height,
      horizontalLines: horizontalLines,
      getHorizontalLines2: HorizontalLine2,
    );
  }
}

class TimeChartData {
  final double y;
  final DateTime time;

  TimeChartData({required this.y, required this.time});
}
