import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:zuurstofmasker/Helpers/serialMocker.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Models/settings.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/config.dart';
import 'dart:math';

class liveSessie extends StatelessWidget {
  liveSessie({super.key});
  final List<TimeChartData> drukGraphData = [];
  final List<TimeChartData> flowGraphData = [];
  final List<TimeChartData> terugvolumeGraphData = [];
  final List<TimeChartData> fi02GraphData = [];
  final List<TimeChartData> sp02GraphData = [];
  final List<TimeChartData> pulseGraphData = [];
  final List<TimeChartData> leakGraphData = [];

  List<FlSpot> randomSpots(
    int xMin,
    int xMax,
    int yMin,
    int yMax,
    int xChange,
  ) {
    final List<FlSpot> spots = [];
    int currentX = xMin;

    for (int i = 0; i <= ((xMax - xMin) / xChange); i++) {
      spots.add(
        FlSpot(
          currentX.toDouble(),
          Random().nextInt((yMax - yMin)).toDouble() + yMin,
        ),
      );
      currentX += xChange;
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 600,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: borderRadius),
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
                                      drukGraphData.last.y.toString(),
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: settings.colors.pressure),
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
                                      flowGraphData.last.y.toString(),
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: settings.colors.flow),
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
                                      terugvolumeGraphData.last.y.toString(),
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: settings.colors.tidalVolume),
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
                                stream: SerialPort('').listen(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    drukGraphData.add(TimeChartData(
                                        y: snapshot.data![0].toDouble(),
                                        time: DateTime.now()));
                                    return TimeChart(
                                      chartData: drukGraphData,
                                      color: settings.colors.pressure,
                                      minY: 70,
                                      maxY: 190,
                                      height: 150,
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                            StreamBuilder(
                                stream: SerialPort('').listen(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    flowGraphData.add(TimeChartData(
                                        y: snapshot.data![0].toDouble(),
                                        time: DateTime.now()));
                                    return TimeChart(
                                      chartData: flowGraphData,
                                      color: settings.colors.flow,
                                      minY: 70,
                                      maxY: 190,
                                      height: 150,
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                            StreamBuilder(
                                stream: SerialPort('').listen(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    terugvolumeGraphData.add(TimeChartData(
                                        y: snapshot.data![0].toDouble(),
                                        time: DateTime.now()));
                                    return TimeChart(
                                      chartData: terugvolumeGraphData,
                                      color: settings.colors.tidalVolume,
                                      minY: 70,
                                      maxY: 190,
                                      height: 150,
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
                ),
                const PaddingSpacing(
                  multiplier: 2,
                ),
                Container(
                  height: 360,
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: borderRadius),
                          child: Row(
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text("Fi02"),
                                    StreamBuilder(
                                        stream: SerialPort('').listen(),
                                        builder: (context, snapshot) {
                                          if (fi02GraphData.length != 0) {
                                            return Text(
                                              fi02GraphData.last.y.toString(),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: settings.colors.fiO2),
                                            );
                                          } else {
                                            return const Text("");
                                          }
                                        }),
                                    const Text("Sp02"),
                                    StreamBuilder(
                                        stream: SerialPort('').listen(),
                                        builder: (context, snapshot) {
                                          if (sp02GraphData.length != 0) {
                                            return Text(
                                              sp02GraphData.last.y.toString(),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: settings.colors.spO2),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    StreamBuilder(
                                        stream: SerialPort('').listen(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            fi02GraphData.add(TimeChartData(
                                                y: snapshot.data![0].toDouble(),
                                                time: DateTime.now()));
                                            return TimeChart(
                                              chartData: fi02GraphData,
                                              color: settings.colors.fiO2,
                                              minY: 70,
                                              maxY: 190,
                                              height: 200,
                                            );
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        }),
                                    StreamBuilder(
                                        stream: SerialPort('').listen(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            sp02GraphData.add(TimeChartData(
                                                y: snapshot.data![0].toDouble(),
                                                time: DateTime.now()));
                                            return TimeChart(
                                              chartData: sp02GraphData,
                                              color: settings.colors.spO2,
                                              minY: 70,
                                              height: 70,
                                              maxY: 190,
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
                        ),
                      ),
                      const PaddingSpacing(
                        multiplier: 2,
                      ),
                      Flexible(
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: borderRadius),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      child: Container(
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius: borderRadius),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              StreamBuilder(
                                                  stream:
                                                      SerialPort('').listen(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      pulseGraphData.add(
                                                          TimeChartData(
                                                              y: snapshot
                                                                  .data![0]
                                                                  .toDouble(),
                                                              time: DateTime
                                                                  .now()));
                                                      return TimeChart(
                                                        chartData:
                                                            pulseGraphData,
                                                        color: settings
                                                            .colors.pulse,
                                                        minY: 70,
                                                        height: 100,
                                                        maxY: 190,
                                                      );
                                                    } else {
                                                      return const CircularProgressIndicator();
                                                    }
                                                  }),
                                              StreamBuilder(
                                                  stream:
                                                      SerialPort('').listen(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      leakGraphData.add(
                                                          TimeChartData(
                                                              y: snapshot
                                                                  .data![0]
                                                                  .toDouble(),
                                                              time: DateTime
                                                                  .now()));
                                                      return TimeChart(
                                                        chartData:
                                                            leakGraphData,
                                                        color: settings
                                                            .colors.leak,
                                                        minY: 70,
                                                        height: 100,
                                                        maxY: 190,
                                                      );
                                                    } else {
                                                      return const CircularProgressIndicator();
                                                    }
                                                  }),
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                child: Button(
                                  onTap: () => {
                                    navigatorKey.currentState!
                                        .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Dashboard()),
                                            (route) => false)
                                  },
                                  text: "homePage",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

List<FlSpot> chartData = [const FlSpot(0, 60)];

List<DataRow> getSessionHistoryItems(List<Session> sessions) {
  List<DataRow> items = [];
  for (var session in sessions) {
    var row = DataRow(
      cells: <DataCell>[
        DataCell(Text(session.id.toString())),
        DataCell(Text(session.birthTime.toString())),
        DataCell(Text(session.nameMother.toString())),
        DataCell(Text(session.note.toString())),
      ],
    );
    items.add(row);
  }
  return items;
}

DataColumn sessionHistoryTitleCell({required String title}) {
  return DataColumn(
    label: Expanded(
      child: Text(
        title,
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
    ),
  );
}
