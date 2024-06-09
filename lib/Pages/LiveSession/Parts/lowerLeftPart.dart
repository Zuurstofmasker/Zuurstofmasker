import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Pages/LiveSession/Functions/chartTreshhold.dart';
import 'package:zuurstofmasker/Pages/LiveSession/liveSession.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Models/sessionSerialData.dart';
import 'dart:async';

class LowerLeftPart extends StatelessWidget {
  LowerLeftPart({
    super.key,
    required this.sessionSerialData,
    required this.sessionActive,
    required this.fiO2Stream,
    required this.spO2Stream,
  });
  final List<TimeChartData> fi02GraphData = [];
  final List<TimeChartData> sp02GraphData = [];
  final SessionSerialData sessionSerialData;
  final ValueNotifier<bool> sessionActive;
  final Stream<Uint8List> fiO2Stream;
  final Stream<Uint8List> spO2Stream;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: pagePadding,
        decoration: BoxDecoration(
          border: Border.all(color: greyTextColor),
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 125,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Fi02", style: liveTitleTextStyle),
                        StreamBuilder(
                          stream: fiO2Stream,
                          builder: (context, snapshot) {
                            return Text(
                              "${fi02GraphData.lastOrNull?.y.toInt() ?? "-"}%",
                              style: TextStyle(
                                  fontSize: 40, color: settings.colors.fiO2),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const PaddingSpacing(
                    multiplier: 2,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sp02", style: liveTitleTextStyle),
                        StreamBuilder(
                          stream: spO2Stream,
                          builder: (context, snapshot) {
                            return Text(
                              "${sp02GraphData.lastOrNull?.y.toInt() ?? "-"}%",
                              style: TextStyle(
                                  fontSize: 40, color: settings.colors.spO2),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 3,
                    child: StreamBuilder(
                      stream: fiO2Stream,
                      builder: (context, snapshot) {
                        saveDateFromStream(snapshot, fi02GraphData);
                        return TimeChart(
                          chartTimeLines: [
                            TimeChartLine(
                              chartData: fi02GraphData,
                              color: settings.colors.fiO2,
                            ),
                          ],
                          chartLines: [generateLowerTreshhold(), generateUpperTreshhold()],
                          minY: 0,
                          maxY: 100,
                          chartSize: 60 * 30,
                          autoScale: true,
                        );
                      },
                    ),
                  ),
                  const PaddingSpacing(
                    multiplier: 2,
                  ),
                  Expanded(
                    flex: 2,
                    child: StreamBuilder(
                      stream: spO2Stream,
                      builder: (context, snapshot) {
                        saveDateFromStream(snapshot, sp02GraphData);
                        return TimeChart(
                          chartTimeLines: [
                            TimeChartLine(
                              chartData: sp02GraphData,
                              color: settings.colors.spO2,
                            )
                          ],
                          minY: 0,
                          maxY: 100,
                          chartSize: 600,
                        );
                      },
                    ),
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
