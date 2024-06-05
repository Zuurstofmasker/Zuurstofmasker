import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/Helpers/serialHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
import 'package:zuurstofmasker/Pages/LiveSessie/liveSession.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/config.dart';

class LowerRightPart extends StatelessWidget {
  LowerRightPart({
    super.key,
    required this.startedSession,
    required this.onStartSession,
    required this.onStopSession,
    required this.onResetSession,
    required this.session,
    required this.pulseStream,
    required this.leakStream,
  });

  final List<TimeChartData> pulseGraphData = [];
  final List<TimeChartData> leakGraphData = [];
  final ValueNotifier<bool> startedSession;
  final Session session;
  final Stream<Uint8List> pulseStream;
  final Stream<Uint8List> leakStream;

  final ValueNotifier<int> timeNotifier = ValueNotifier<int>(0);

  final Function() onStartSession;
  final Function() onStopSession;
  final Function() onResetSession;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: pagePadding,
        height: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: greyTextColor),
            borderRadius: borderRadius),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 125,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Pulse", style: liveTitleTextStyle),
                        StreamBuilder(
                          stream: pulseStream,
                          builder: (context, snapshot) {
                            return Text(
                              pulseGraphData.lastOrNull?.y.toInt().toString() ??
                                  "-",
                              style: TextStyle(
                                  fontSize: 40, color: settings.colors.pulse),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const PaddingSpacing(multiplier: 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Leak", style: liveTitleTextStyle),
                        StreamBuilder(
                          stream: leakStream,
                          builder: (context, snapshot) {
                            return Text(
                              "${leakGraphData.lastOrNull?.y.toInt() ?? "-"}%",
                              style: TextStyle(
                                  fontSize: 40, color: settings.colors.leak),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: SizedBox(
                      height: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: StreamBuilder(
                              stream: pulseStream,
                              builder: (context, snapshot) {
                                saveDateFromStream(snapshot, pulseGraphData);
                                return TimeChart(
                                  chartTimeLines: [
                                    TimeChartLine(
                                      chartData: pulseGraphData,
                                      color: settings.colors.pulse,
                                    )
                                  ],
                                  minY: 30,
                                  maxY: 225,
                                  autoScale: true,
                                  chartSize: 600,
                                );
                              },
                            ),
                          ),
                          const PaddingSpacing(multiplier: 2),
                          Expanded(
                            child: StreamBuilder(
                              stream: leakStream,
                              builder: (context, snapshot) {
                                saveDateFromStream(snapshot, leakGraphData);
                                return TimeChart(
                                  chartTimeLines: [
                                    TimeChartLine(
                                      chartData: leakGraphData,
                                      color: settings.colors.leak,
                                    )
                                  ],
                                  minY: 0,
                                  maxY: 100,
                                  autoScale: true,
                                  chartSize: 600,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const PaddingSpacing(multiplier: 2),
            SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ValueListenableBuilder(
                      valueListenable: timeNotifier,
                      builder: (context, value, child) {
                        // Updates the widget every second
                        Timer(const Duration(seconds: 1), () {
                          timeNotifier.value++;
                        });

                        // Retrieving the elapsed time
                        Duration time =
                            DateTime.now().difference(session.birthDateTime);

                        return Text(
                          (!startedSession.value
                              ? "00:00"
                              : "${time.inMinutes.remainder(60).toString().padLeft(2, '0')}:${time.inSeconds.remainder(60).toString().padLeft(2, '0')}"),
                          style: const TextStyle(fontSize: 80),
                        );
                      }),
                  ValueListenableBuilder(
                      valueListenable: startedSession,
                      builder: (context, value, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: !value
                              ? [
                                  Button(
                                      onTap: onStartSession,
                                      text: "Start opvang"),
                                  Button(
                                    text: "Annuleren",
                                    onTap: () {
                                      replaceAllPages(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Dashboard()),
                                          context: context);
                                    },
                                  ),
                                ]
                              : [
                                  Button(
                                      onTap: onResetSession,
                                      text: "Reset opvang"),
                                  Button(
                                      onTap: onStopSession, text: "Stop opvang")
                                ],
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
