import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Pages/LiveSessie/lowerLeftPart.dart';
import 'package:zuurstofmasker/Pages/LiveSessie/lowerRightPart.dart';
import 'package:zuurstofmasker/Pages/LiveSessie/upperPart.dart';
import 'package:zuurstofmasker/Widgets/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/config.dart';

class liveSessie extends StatelessWidget {
  liveSessie({super.key});
  final List<TimeChartData> drukGraphData = [];
  final List<TimeChartData> flowGraphData = [];
  final List<TimeChartData> terugvolumeGraphData = [];
  final List<TimeChartData> fi02GraphData = [];
  final List<TimeChartData> sp02GraphData = [];
  final List<TimeChartData> pulseGraphData = [];
  final List<TimeChartData> leakGraphData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                upperPart(),
                const PaddingSpacing(
                  multiplier: 2,
                ),
                Container(
                  height: 360,
                  child: Row(
                    children: [
                      lowerLeftPart(),
                      const PaddingSpacing(
                        multiplier: 2,
                      ),
                      lowerRightPart()
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
