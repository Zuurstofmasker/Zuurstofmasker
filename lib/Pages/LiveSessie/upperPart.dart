import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:zuurstofmasker/Helpers/serialMocker.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Models/sessionSerialData.dart';
import 'dart:async';

class UpperPart extends StatelessWidget {
  UpperPart({
    super.key,
    required this.sessionSerialData,
    required this.sessionActive,
    required this.flowStream,
    required this.patientStream,
    required this.vtiStream,
    this.serialTimeOut,
    required this.timeoutCallback,
  });
  final List<TimeChartData> drukGraphData = [];
  final List<TimeChartData> flowGraphData = [];
  final List<TimeChartData> terugvolumeGraphData = [];
  final SessionSerialData sessionSerialData;
  final ValueNotifier<bool> sessionActive;
  final Stream<Uint8List> flowStream;
  final Stream<Uint8List> patientStream;
  final Stream<Uint8List> vtiStream;

  Timer? serialTimeOut;
  final Function timeoutCallback;

  TextStyle getsubTitleTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      decoration: BoxDecoration(
        border: Border.all(color: greyTextColor),
        borderRadius: borderRadius,
      ),
      child: Row(
        children: [
          Container(
            height: double.infinity,
            width: 250,
            padding: pagePadding,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: greyTextColor),
              ),
              borderRadius: borderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Druk", style: liveTitleTextStyle),
                      const Spacer(),
                      SizedBox(
                        width: 75,
                        child: StreamBuilder(
                          stream: SerialPort('').listen(),
                          builder: (context, snapshot) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PIP",
                                  style: getsubTitleTextStyle(
                                    settings.colors.pressure,
                                  ),
                                ),
                                Text(
                                  drukGraphData.isEmpty
                                      ? "-"
                                      : drukGraphData.last.y.toInt().toString(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: settings.colors.pressure,
                                  ),
                                ),
                                const PaddingSpacing(multiplier: 0.5,),
                                Text("PEEP",
                                    style: getsubTitleTextStyle(
                                        settings.colors.pressure)),
                                Text(
                                  drukGraphData.isEmpty
                                      ? "-"
                                      : drukGraphData.last.y.toInt().toString(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: settings.colors.pressure,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const PaddingSpacing(
                  multiplier: 2,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Flow", style: liveTitleTextStyle),
                      const PaddingSpacing(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 75,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Resp",
                                style: getsubTitleTextStyle(
                                  settings.colors.flow,
                                ),
                              ),
                              StreamBuilder(
                                stream: SerialPort('').listen(),
                                builder: (context, snapshot) {
                                  return Text(
                                    flowGraphData.isEmpty
                                        ? "-"
                                        : flowGraphData.last.y
                                            .toInt()
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: settings.colors.flow,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const PaddingSpacing(
                  multiplier: 2,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Teugvolume", style: liveTitleTextStyle),
                      const PaddingSpacing(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 75,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Insp",
                                style: getsubTitleTextStyle(
                                  settings.colors.tidalVolume,
                                ),
                              ),
                              StreamBuilder(
                                stream: SerialPort('').listen(),
                                builder: (context, snapshot) {
                                  return Text(
                                    terugvolumeGraphData.isEmpty
                                        ? "-"
                                        : terugvolumeGraphData.last.y
                                            .toInt()
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: settings.colors.tidalVolume,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: pagePadding.copyWith(left: 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: StreamBuilder(
                      stream: flowStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // serialTimeOut = Timer(const Duration(seconds: 5), timeoutCallback());
                          drukGraphData.add(TimeChartData(
                              y: snapshot.data![0].toDouble(),
                              time: DateTime.now()));
                          sessionSerialData.stateOutFlow.add(snapshot.data![0].toDouble());
                          sessionSerialData.stateOutSeconds.add(DateTime.now());
                        }
                        return TimeChart(
                          chartData: TimeChartLine(
                            chartData: drukGraphData,
                            color: settings.colors.pressure,
                          ),
                          minY: 0,
                          maxY: 40,
                          horizontalLinesValues: const [25],
                        );
                      },
                    ),
                  ),
                  const PaddingSpacing(
                    multiplier: 2,
                  ),
                  Flexible(
                    child: StreamBuilder(
                      stream: patientStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // serialTimeOut = Timer(const Duration(seconds: 5), timeoutCallback());
                          flowGraphData.add(TimeChartData(
                              y: snapshot.data![0].toDouble(),
                              time: DateTime.now()));
                          sessionSerialData.patientFlow.add(snapshot.data![0].toDouble());
                          sessionSerialData.patientSeconds.add(DateTime.now());
                        }
                        return TimeChart(
                          chartData: TimeChartLine(
                              chartData: flowGraphData,
                              color: settings.colors.flow),
                          minY: -75,
                          maxY: 75,
                          horizontalLinesValues: const [0],
                        );
                      },
                    ),
                  ),
                  const PaddingSpacing(
                    multiplier: 2,
                  ),
                  Flexible(
                    child: StreamBuilder(
                      stream: vtiStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // serialTimeOut = Timer(const Duration(seconds: 5), timeoutCallback());
                          terugvolumeGraphData.add(TimeChartData(
                              y: snapshot.data![0].toDouble(),
                              time: DateTime.now()));
                          sessionSerialData.vti.add(snapshot.data![0].toDouble());
                          sessionSerialData.vtiSeconds.add(DateTime.now());
                        }
                        return TimeChart(
                          chartData: TimeChartLine(
                              chartData: terugvolumeGraphData,
                              color: settings.colors.tidalVolume),
                          minY: 0,
                          maxY: 10,
                          horizontalLinesValues: const [4, 8],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
