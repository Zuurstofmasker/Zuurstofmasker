import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:zuurstofmasker/Helpers/serialMocker.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/config.dart';

class LowerRightPart extends StatelessWidget {
  LowerRightPart({super.key});
  final List<TimeChartData> pulseGraphData = [];
  final List<TimeChartData> leakGraphData = [];

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
                          stream: SerialPort('').listen(),
                          builder: (context, snapshot) {
                            return Text(
                              pulseGraphData.isEmpty
                                  ? "-"
                                  : pulseGraphData.last.y.toInt().toString(),
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
                          stream: SerialPort('').listen(),
                          builder: (context, snapshot) {
                            if (leakGraphData.isNotEmpty) {
                              return Text(
                                "${leakGraphData.last.y.toInt()}%",
                                style: TextStyle(
                                    fontSize: 40, color: settings.colors.leak),
                              );
                            } else {
                              return const Text("");
                            }
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
                              stream: SerialPort('').listen(min: 30, max: 225),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  pulseGraphData.add(TimeChartData(
                                      y: snapshot.data![0].toDouble(),
                                      time: DateTime.now()));
                                }
                                return TimeChart(
                                  chartData: TimeChartLine(
                                      chartData: pulseGraphData,
                                      color: settings.colors.pulse),
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
                              stream: SerialPort('').listen(min: 0, max: 100),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  leakGraphData.add(TimeChartData(
                                      y: snapshot.data![0].toDouble(),
                                      time: DateTime.now()));
                                }
                                return TimeChart(
                                  chartData: TimeChartLine(
                                      chartData: leakGraphData,
                                      color: settings.colors.leak),
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
                  const Text("08:32",style: TextStyle(fontSize: 80),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Button(
                        onTap: () => {
                          replaceAllPages(
                              MaterialPageRoute(builder: (context) => const Dashboard()))
                        },
                        text: "homePage",
                      ),
                    ],
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
