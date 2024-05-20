import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/Charts/charts.dart';

class TimeChart extends StatelessWidget {
  TimeChart(
      {super.key,
      required this.chartData,
      this.chartLines = const [],
      this.autoScale = false,
      this.initalTime,
      this.chartSize = 30,
      this.maxY,
      this.minY,
      this.height,
      this.horizontalLinesValues}) {
    setChartData();
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

  late DateTime? initalTime;
  final double chartSize;
  final bool autoScale;
  final TimeChartLine chartData;
  final List<ChartLine> chartLines;
  final double? minY;
  final double? maxY;
  final double? height;
  late List<FlSpot> chartDataLine = [];
  final List<double>? horizontalLinesValues;

  List<HorizontalLine>? horizontalLine;

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

  // List<FlSpot> getOptionalChartData() {
  //   List<FlSpot> items = [];
  //   if (showFi02Lines != null && showFi02Lines!) {
  //     startTime ??= DateTime.now().subtract(const Duration(seconds: 600));
  //     var test = startTime!.add(Duration(seconds: 0));
  //     items.add(FlSpot(differenceToSecdonds(test, startTime!).toDouble(), 0));
  //     test = startTime!.add(Duration(seconds: 120));
  //     items.add(FlSpot(differenceToSecdonds(test, startTime!).toDouble(), 60));
  //     test = startTime!.add(Duration(seconds: 300));
  //     items.add(FlSpot(differenceToSecdonds(test, startTime!).toDouble(), 85));
  //     test = startTime!.add(Duration(seconds: 600));
  //     items.add(FlSpot(differenceToSecdonds(test, startTime!).toDouble(), 90));
  //   }
  //   return items;
  // }

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

typedef TimeChartLine = ChartLineBase<TimeChartData>;

class TimeChartData {
  final double y;
  final DateTime time;

  TimeChartData({required this.y, required this.time});
}
