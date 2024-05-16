import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:zuurstofmasker/Helpers/serialMocker.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
import 'package:zuurstofmasker/Widgets/Charts/TimeChart.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';

class lowerRightPart extends StatelessWidget {
  lowerRightPart({super.key});
  final List<TimeChartData> pulseGraphData = [];
  final List<TimeChartData> leakGraphData = [];

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: borderRadius),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Pulse"),
                StreamBuilder(
                    stream: SerialPort('').listen(),
                    builder: (context, snapshot) {
                      if (pulseGraphData.length != 0) {
                        return Text(
                          pulseGraphData.last.y.toInt().toString(),
                          style: TextStyle(
                              fontSize: 30, color: settings.colors.pulse),
                        );
                      } else {
                        return const Text("");
                      }
                    }),
                const Text("Leak"),
                StreamBuilder(
                    stream: SerialPort('').listen(),
                    builder: (context, snapshot) {
                      if (leakGraphData.length != 0) {
                        return Text(
                          "${leakGraphData.last.y.toInt()}%",
                          style: TextStyle(
                              fontSize: 30, color: settings.colors.leak),
                        );
                      } else {
                        return const Text("");
                      }
                    }),
              ],
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Container(
                        height: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StreamBuilder(
                                stream:
                                    SerialPort('').listen(min: 30, max: 225),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    pulseGraphData.add(TimeChartData(
                                        y: snapshot.data![0].toDouble(),
                                        time: DateTime.now()));
                                  }
                                  return TimeChart(
                                    chartData: pulseGraphData,
                                    color: settings.colors.pulse,
                                    minY: 30,
                                    height: 140,
                                    maxY: 225,
                                  );
                                }),
                            StreamBuilder(
                                stream: SerialPort('').listen(min: 0, max: 100),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    leakGraphData.add(TimeChartData(
                                        y: snapshot.data![0].toDouble(),
                                        time: DateTime.now()));
                                  }
                                  return TimeChart(
                                    chartData: leakGraphData,
                                    color: settings.colors.leak,
                                    minY: 0,
                                    height: 140,
                                    maxY: 100,
                                  );
                                }),
                          ],
                        )),
                  )
                ],
              ),
            ),
            Button(
              onTap: () => {
                replaceAllPages(
                    MaterialPageRoute(builder: (context) => const Dashboard()))
              },
              text: "homePage",
            ),
          ],
        ),
      ),
    );
  }
}
