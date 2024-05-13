import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/Charts/charts.dart';

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
      this.horizontalLinesValues,
      this.showFi02Lines}) {
    startTime ??= DateTime.now().subtract(const Duration(seconds: 30));
    endTime ??= DateTime.now();

    List<HorizontalLine> getHorizontalLines() {
      var allitems = List<HorizontalLine>.empty(growable: true);

      var items = horizontalLinesValues
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

    horizontalLine = getHorizontalLines();
  }

  late DateTime? startTime;
  late DateTime? endTime;
  final List<TimeChartData> chartData;
  final Color color;
  final double? minY;
  final double? maxY;
  final double? height;
  final List<double>? horizontalLinesValues;
  final bool? showFi02Lines;

  List<HorizontalLine>? horizontalLine;
  List<FlSpot> getChartData() {
    List<FlSpot> items = [];
    for (TimeChartData data in chartData) {
      items.add(
        FlSpot(differenceToSecdonds(data.time, startTime!).toDouble(), data.y),
      );
    }
    return items;
  }

  List<FlSpot> getOptionalChartData() {
    List<FlSpot> items = [];
    if (showFi02Lines != null && showFi02Lines!) {
      startTime ??= DateTime.now().subtract(const Duration(seconds: 600));
      var test = startTime!.add(Duration(seconds: 0));
      items.add(FlSpot(differenceToSecdonds(test, startTime!).toDouble(), 0));
      test = startTime!.add(Duration(seconds: 120));
      items.add(FlSpot(differenceToSecdonds(test, startTime!).toDouble(), 60));
      test = startTime!.add(Duration(seconds: 300));
      items.add(FlSpot(differenceToSecdonds(test, startTime!).toDouble(), 85));
      test = startTime!.add(Duration(seconds: 600));
      items.add(FlSpot(differenceToSecdonds(test, startTime!).toDouble(), 90));
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
      optionalChartData: getOptionalChartData(),
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
      horizontalLines: horizontalLine,
    );
  }
}

class TimeChartData {
  final double y;
  final DateTime time;

  TimeChartData({required this.y, required this.time});
}
