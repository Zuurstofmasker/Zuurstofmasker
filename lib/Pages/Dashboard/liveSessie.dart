import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:zuurstofmasker/config.dart';

class liveSessie extends StatelessWidget {
  const liveSessie({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(15.0),
                        height: 450,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: const Column(
                          children: [
                            Text("Druk"),
                            Text("Flow"),
                            Text("Teugvolume")
                          ],
                        ),
                      ),
                      Container(
                          child: Flexible(
                        child: Column(
                          children: [
                            Chart(
                              chartData: chartData,
                              color: Colors.blue,
                              height: 150,
                              bottomTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            Chart(
                              chartData: chartData,
                              color: Colors.blue,
                              height: 150,
                              bottomTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            Chart(
                              chartData: chartData,
                              color: Colors.blue,
                              height: 150,
                              bottomTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    children: [
                      Container(
                        width: 721,
                        height: 300,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          children: [
                            const Column(
                              children: [
                                Text("Fi02"),
                                Text(
                                  "21%",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.purple),
                                ),
                                Text("Sp02"),
                                Text(
                                  "84%",
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Chart(
                                  chartData: chartData,
                                  color: Colors.blue,
                                  height: 200,
                                  width: 400,
                                  bottomTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                Chart(
                                  chartData: chartData,
                                  color: Colors.blue,
                                  height: 75,
                                  width: 400,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 300,
                        width: 721,
                        margin: const EdgeInsets.only(left: 30),
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                    height: 268,
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        Chart(
                                          chartData: chartData,
                                          color: Colors.blue,
                                          height: 118,
                                          width: 400,
                                        ),
                                        Chart(
                                          chartData: chartData,
                                          color: Colors.blue,
                                          height: 118,
                                          width: 400,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                            Container(
                              child: Button(
                                onTap: () => {
                                  navigatorKey.currentState!.pushAndRemoveUntil(
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
