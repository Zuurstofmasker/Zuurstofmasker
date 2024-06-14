import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Pages/LiveSession/liveSession.dart';
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
    required this.pressureStream,
    required this.flowStream,
    required this.tidalVolumeStream,
  });
  final List<TimeChartData> pressureGraphData = [];
  final List<TimeChartData> flowData = [];
  final List<TimeChartData> tidalVolumeGraphData = [];
  final SessionSerialData sessionSerialData;
  final ValueNotifier<bool> sessionActive;
  final Stream<Uint8List> pressureStream;
  final Stream<Uint8List> flowStream;
  final Stream<Uint8List> tidalVolumeStream;

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
                          stream: pressureStream,
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
                                  pressureGraphData.lastOrNull?.y
                                          .toInt()
                                          .toString() ??
                                      "-",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: settings.colors.pressure,
                                  ),
                                ),
                                const PaddingSpacing(
                                  multiplier: 0.5,
                                ),
                                Text("PEEP",
                                    style: getsubTitleTextStyle(
                                        settings.colors.pressure)),
                                Text(
                                  pressureGraphData.lastOrNull?.y
                                          .toInt()
                                          .toString() ??
                                      "-",
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
                                stream: flowStream,
                                builder: (context, snapshot) {
                                  return Text(
                                    flowData.lastOrNull?.y.toInt().toString() ??
                                        "-",
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
                                stream: tidalVolumeStream,
                                builder: (context, snapshot) {
                                  return Text(
                                    tidalVolumeGraphData.lastOrNull?.y
                                            .toInt()
                                            .toString() ??
                                        "-",
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
                      stream: pressureStream,
                      builder: (context, snapshot) {
                        saveDateFromStream(snapshot, pressureGraphData);
                        return TimeChart(
                          chartTimeLines: [
                            TimeChartLine(
                              chartData: pressureGraphData,
                              color: settings.colors.pressure,
                            )
                          ],
                          minY: 0,
                          maxY: 40,
                          horizontalLines: const [25],
                        );
                      },
                    ),
                  ),
                  const PaddingSpacing(
                    multiplier: 2,
                  ),
                  Flexible(
                    child: StreamBuilder(
                      stream: flowStream,
                      builder: (context, snapshot) {
                        saveDateFromStream(snapshot, flowData);
                        return TimeChart(
                          chartTimeLines: [
                            TimeChartLine(
                              chartData: flowData,
                              color: settings.colors.flow,
                            )
                          ],
                          minY: -75,
                          maxY: 75,
                          horizontalLines: const [0],
                        );
                      },
                    ),
                  ),
                  const PaddingSpacing(
                    multiplier: 2,
                  ),
                  Flexible(
                    child: StreamBuilder(
                      stream: tidalVolumeStream,
                      builder: (context, snapshot) {
                        saveDateFromStream(snapshot, tidalVolumeGraphData);
                        return TimeChart(
                          chartTimeLines: [
                            TimeChartLine(
                              chartData: tidalVolumeGraphData,
                              color: settings.colors.tidalVolume,
                            )
                          ],
                          minY: 0,
                          maxY: 10,
                          horizontalLines: const [4, 8],
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
