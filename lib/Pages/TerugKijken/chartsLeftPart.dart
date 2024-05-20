import 'package:flutter/material.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';

class ChartsLeftPart extends StatelessWidget {
  ChartsLeftPart({super.key});
  final List<TimeChartData> pulseGraphData = [];
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
                  ),
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
                        chartData: spO2GraphData, color: settings.colors.spO2),
                    minY: 0,
                    height: 195,
                    maxY: 100,
                    chartSize: 600,
                  ),
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
