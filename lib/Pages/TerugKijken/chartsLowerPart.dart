import 'package:flutter/material.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:zuurstofmasker/Widgets/Charts/TimeChart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';

class ChartsLowerPart extends StatelessWidget {
  ChartsLowerPart({super.key});

  final List<TimeChartData> LeakGraphData = [];
  final List<TimeChartData> PressureGraphData = [];
  final List<TimeChartData> FlowGraphData = [];
  final List<TimeChartData> TidalVolumeGraphData = [];
  final double sessionLength = 600;
  final double widthGraph = 442;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: double.infinity,
        width: 800,
        child: Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: mainPadding,
                height: 285,
                width: widthGraph,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: borderRadius),
                child: Column(
                  children: [
                    const Text(
                      "Leak",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TimeChart(
                      chartData: TimeChartLine(
                          chartData: LeakGraphData,
                          color: settings.colors.leak),
                      minY: 0,
                      height: 195,
                      maxY: 100,
                      chartSize: 600,
                    ),
                    const Text(
                      "15%",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                width: widthGraph,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: borderRadius),
                child: Column(
                  children: [
                    const Text(
                      "Druk",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TimeChart(
                      chartData: TimeChartLine(
                          chartData: PressureGraphData,
                          color: settings.colors.pressure),
                      minY: 0,
                      height: 195,
                      maxY: 100,
                      chartSize: 600,
                    ),
                    const Text(
                      "7",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                width: widthGraph,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: borderRadius),
                child: Column(
                  children: [
                    const Text(
                      "Flow",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TimeChart(
                      chartData: TimeChartLine(
                          chartData: FlowGraphData,
                          color: settings.colors.flow),
                      minY: 0,
                      height: 195,
                      maxY: 100,
                      chartSize: 600,
                    ),
                    const Text(
                      "56",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                width: widthGraph,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: borderRadius),
                child: Column(
                  children: [
                    const Text(
                      "Terugvolume",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TimeChart(
                      chartData: TimeChartLine(
                          chartData: TidalVolumeGraphData,
                          color: settings.colors.tidalVolume),
                      minY: 0,
                      height: 195,
                      maxY: 100,
                      chartSize: 600,
                    ),
                    const Text(
                      "15",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
