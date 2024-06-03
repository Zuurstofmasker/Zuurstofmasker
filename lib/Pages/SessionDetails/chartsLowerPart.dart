import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';

class ChartsLowerPart extends StatelessWidget {
  const ChartsLowerPart({
    super.key,
    required this.session,
    required this.callback,
    required this.runTime,
    required this.duration,
    required this.leakGraphData,
    required this.pressureGraphData,
    required this.flowGraphData,
    required this.tidalVolumeGraphData,
  });
  final void Function(LineTouchResponse?, double?) callback;

  final Session session;
  final int runTime;
  final int duration;

  final List<TimeChartData> leakGraphData;
  final List<TimeChartData> pressureGraphData;
  final List<TimeChartData> flowGraphData;
  final List<TimeChartData> tidalVolumeGraphData;
  final double sessionLength = 600;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            padding: mainPadding,
            height: 285,
            decoration: BoxDecoration(
                border: Border.all(color: greyTextColor),
                borderRadius: borderRadius),
            child: Column(
              children: [
                const Text(
                  "Leak",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TimeChart(
                  chartData: TimeChartLine(
                      chartData: leakGraphData, color: settings.colors.leak),
                  minY: 0,
                  height: 195,
                  maxY: 100,
                  chartSize: 0,
                  autoScale: true,
                  onLineTouch: callback,
                ),
                // const Text(
                //   "15%",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
        ),
        const PaddingSpacing(
          multiplier: 2,
        ),
        Expanded(
          child: Container(
            padding: mainPadding,
            height: 285,
            decoration: BoxDecoration(
                border: Border.all(color: greyTextColor),
                borderRadius: borderRadius),
            child: Column(
              children: [
                const Text(
                  "Druk",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TimeChart(
                    chartData: TimeChartLine(
                        chartData: pressureGraphData,
                        color: settings.colors.pressure),
                    minY: 0,
                    height: 195,
                    chartSize: 0,
                    autoScale: true,
                    maxY: 40,
                    onLineTouch: callback),
                // const Text(
                //   "7",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
        ),
        const PaddingSpacing(
          multiplier: 2,
        ),
        Expanded(
          child: Container(
            padding: mainPadding,
            height: 285,
            decoration: BoxDecoration(
                border: Border.all(color: greyTextColor),
                borderRadius: borderRadius),
            child: Column(
              children: [
                const Text(
                  "Flow",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TimeChart(
                    chartData: TimeChartLine(
                        chartData: flowGraphData, color: settings.colors.flow),
                    minY: -75,
                    height: 195,
                    maxY: 75,
                    chartSize: 0,
                    autoScale: true,
                    onLineTouch: callback),
                // const Text(
                //   "56",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
        ),
        const PaddingSpacing(
          multiplier: 2,
        ),
        Expanded(
          child: Container(
            padding: mainPadding,
            height: 285,
            decoration: BoxDecoration(
                border: Border.all(color: greyTextColor),
                borderRadius: borderRadius),
            child: Column(
              children: [
                const Text(
                  "Terugvolume",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TimeChart(
                    chartData: TimeChartLine(
                        chartData: tidalVolumeGraphData,
                        color: settings.colors.tidalVolume),
                    minY: 0,
                    height: 195,
                    maxY: 10,
                    chartSize: 0,
                    autoScale: true,
                    onLineTouch: callback),
                // const Text(
                //   "15",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
