import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:zuurstofmasker/Helpers/serialMocker.dart';
import 'package:zuurstofmasker/Widgets/charts.dart';
import 'package:zuurstofmasker/config.dart';

class upperPart extends StatelessWidget {
  upperPart({super.key});
  final List<TimeChartData> drukGraphData = [];
  final List<TimeChartData> flowGraphData = [];
  final List<TimeChartData> terugvolumeGraphData = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black), borderRadius: borderRadius),
      child: Row(
        children: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: borderRadius),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Druk"),
                StreamBuilder(
                    stream: SerialPort('').listen(),
                    builder: (context, snapshot) {
                      if (drukGraphData.length != 0) {
                        return Text(
                          drukGraphData.last.y.toInt().toString(),
                          style: TextStyle(
                              fontSize: 30, color: settings.colors.pressure),
                        );
                      } else {
                        return const Text("");
                      }
                    }),
                const Text("Flow"),
                StreamBuilder(
                    stream: SerialPort('').listen(),
                    builder: (context, snapshot) {
                      if (flowGraphData.length != 0) {
                        return Text(
                          flowGraphData.last.y.toInt().toString(),
                          style: TextStyle(
                              fontSize: 30, color: settings.colors.flow),
                        );
                      } else {
                        return const Text("");
                      }
                    }),
                const Text("Teugvolume"),
                StreamBuilder(
                    stream: SerialPort('').listen(),
                    builder: (context, snapshot) {
                      if (terugvolumeGraphData.length != 0) {
                        return Text(
                          terugvolumeGraphData.last.y.toInt().toString(),
                          style: TextStyle(
                              fontSize: 30, color: settings.colors.tidalVolume),
                        );
                      } else {
                        return const Text("");
                      }
                    }),
              ],
            ),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                StreamBuilder(
                    stream: SerialPort('').listen(min: 0, max: 40),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        drukGraphData.add(TimeChartData(
                            y: snapshot.data![0].toDouble(),
                            time: DateTime.now()));
                        return TimeChart(
                          chartData: drukGraphData,
                          color: settings.colors.pressure,
                          minY: 0,
                          maxY: 40,
                          height: 150,
                          horizontalLines: const [25],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
                StreamBuilder(
                    stream: SerialPort('').listen(min: -75, max: 75),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        flowGraphData.add(TimeChartData(
                            y: snapshot.data![0].toDouble(),
                            time: DateTime.now()));
                        return TimeChart(
                          chartData: flowGraphData,
                          color: settings.colors.flow,
                          minY: -75,
                          maxY: 75,
                          height: 150,
                          horizontalLines: const [0],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
                StreamBuilder(
                    stream: SerialPort('').listen(min: 0, max: 10),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        terugvolumeGraphData.add(TimeChartData(
                            y: snapshot.data![0].toDouble(),
                            time: DateTime.now()));
                        return TimeChart(
                          chartData: terugvolumeGraphData,
                          color: settings.colors.tidalVolume,
                          minY: 0,
                          maxY: 10,
                          height: 150,
                          horizontalLines: const [4, 8],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
