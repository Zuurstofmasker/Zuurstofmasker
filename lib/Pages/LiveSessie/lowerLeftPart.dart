import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:zuurstofmasker/Helpers/serialMocker.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/config.dart';

class LowerLeftPart extends StatelessWidget {
  LowerLeftPart({super.key});
  final List<TimeChartData> fi02GraphData = [];
  final List<TimeChartData> sp02GraphData = [];

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Fi02"),
                StreamBuilder(
                  stream: SerialPort('').listen(),
                  builder: (context, snapshot) {
                    if (fi02GraphData.isNotEmpty) {
                      return Text(
                        "${fi02GraphData.last.y.toInt()}%",
                        style: TextStyle(
                            fontSize: 30, color: settings.colors.fiO2),
                      );
                    } else {
                      return const Text("");
                    }
                  },
                ),
                const Text("Sp02"),
                StreamBuilder(
                  stream: SerialPort('').listen(),
                  builder: (context, snapshot) {
                    if (sp02GraphData.isNotEmpty) {
                      return Text(
                        "${sp02GraphData.last.y.toInt()}%",
                        style: TextStyle(
                            fontSize: 30, color: settings.colors.spO2),
                      );
                    } else {
                      return const Text("");
                    }
                  },
                ),
              ],
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  StreamBuilder(
                    stream: SerialPort('').listen(min: 0, max: 100),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        fi02GraphData.add(TimeChartData(
                            y: snapshot.data![0].toDouble(),
                            time: DateTime.now()));
                      }
                      return TimeChart(
                        chartData: TimeChartLine(
                          chartData: fi02GraphData,
                          color: settings.colors.fiO2,
                        ),
                        minY: 0,
                        maxY: 100,
                        height: 200,
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: SerialPort('').listen(min: 0, max: 100),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        sp02GraphData.add(
                          TimeChartData(
                            y: snapshot.data![0].toDouble(),
                            time: DateTime.now(),
                          ),
                        );
                      }
                      return TimeChart(
                        chartData: TimeChartLine(
                          chartData: sp02GraphData,
                          color: settings.colors.spO2,
                        ),
                        minY: 0,
                        height: 100,
                        maxY: 100,
                        chartSize: 600,
                      );
                    },
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
