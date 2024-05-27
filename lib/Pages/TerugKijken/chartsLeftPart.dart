import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';

class ChartsLeftPart extends StatelessWidget {
  ChartsLeftPart(
      {super.key,
      required this.session,
      required this.callback,
      required this.runTime});
  final void Function(LineTouchResponse?, double?) callback;
  final Session session;
  final int runTime;

  final List<TimeChartData> pulseGraphData = [
    TimeChartData(time: DateTime.now(), y: 10),
    TimeChartData(time: DateTime.now().add(Duration(seconds: 1)), y: 10),
    TimeChartData(time: DateTime.now().add(Duration(seconds: 2)), y: 10),
    TimeChartData(time: DateTime.now().add(Duration(seconds: 3)), y: 10),
    TimeChartData(time: DateTime.now().add(Duration(seconds: 4)), y: 10),
    TimeChartData(time: DateTime.now().add(Duration(seconds: 5)), y: 10),
    TimeChartData(time: DateTime.now().add(Duration(seconds: 6)), y: 10),
    TimeChartData(time: DateTime.now().add(Duration(seconds: 7)), y: 10),
    TimeChartData(time: DateTime.now().add(Duration(seconds: 8)), y: 10),
    // TimeChartData(time: DateTime.now().add(Duration(seconds: 20)), y: 10),
    // TimeChartData(time: DateTime.now().add(Duration(seconds: 30)), y: 10),
    // TimeChartData(time: DateTime.now().add(Duration(seconds: 40)), y: 10),
    // TimeChartData(time: DateTime.now().add(Duration(seconds: 50)), y: 10),
  ];
  final List<TimeChartData> spO2GraphData = [];

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: mainPadding,
              height: 285,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: borderRadius),
              child: Column(
                children: [
                  const Text(
                    "Pulse",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TimeChart(
                      chartData: TimeChartLine(
                          chartData: pulseGraphData,
                          color: settings.colors.pulse),
                      minY: 0,
                      maxY: 100,
                      height: 195,
                      onLineTouch: callback),
                  const Text(
                    "135",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const PaddingSpacing(
              multiplier: 2,
            ),
            Container(
              padding: mainPadding,
              height: 285,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: borderRadius),
              child: Column(
                children: [
                  const Text(
                    "SP02",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TimeChart(
                      chartData: TimeChartLine(
                          chartData: spO2GraphData,
                          color: settings.colors.spO2),
                      minY: 0,
                      height: 195,
                      maxY: 100,
                      chartSize: 600,
                      onLineTouch: callback),
                  const Text(
                    "15%",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
