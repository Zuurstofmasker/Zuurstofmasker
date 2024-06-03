import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';

class ChartsLeftPart extends StatelessWidget {
  const ChartsLeftPart({
    super.key,
    required this.session,
    required this.callback,
    required this.runTime,
    required this.duration,
    required this.pulseGraphData,
    required this.spO2GraphData,
  });
  final void Function(LineTouchResponse?, double?) callback;
  final Session session;
  final int runTime;
  final int duration;

  final List<TimeChartData> pulseGraphData;
  final List<TimeChartData> spO2GraphData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: mainPadding,
          height: 285,
          decoration: BoxDecoration(
              border: Border.all(color: greyTextColor),
              borderRadius: borderRadius),
          child: Column(
            children: [
              const Text(
                "Pulse",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TimeChart(
                chartData: TimeChartLine(
                    chartData: pulseGraphData, color: settings.colors.pulse),
                minY: 30,
                maxY: 225,
                height: 195,
                chartSize: 0,
                autoScale: true,
                onLineTouch: callback,
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
              border: Border.all(color: greyTextColor),
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
                chartSize: 0,
                autoScale: true,
                onLineTouch: callback,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
