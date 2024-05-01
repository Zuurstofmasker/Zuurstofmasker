import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/titles.dart';
import 'package:zuurstofmasker/config.dart';

class SessionHistory extends StatelessWidget {
  const SessionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Nav(
      child: ListView(
        padding: pagePadding,
        children: [
          const PageTitle(title: 'Sessie geschiedenis'),
          const PaddingSpacing(multiplier: 2),
          FutureBuilder(
              future: getSessions(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const SizedBox();
                }
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return DataTable(
                    border: TableBorder.all(borderRadius: borderRadius),
                    headingRowHeight: 40,
                    columns: <DataColumn>[
                      sessionHistoryTitleCell(title: 'ID'),
                      sessionHistoryTitleCell(title: 'Geboorte datum'),
                      sessionHistoryTitleCell(title: 'Naam moeder'),
                      sessionHistoryTitleCell(title: 'Opmerking'),
                    ],
                    rows: getSessionHistoryItems(snapshot.data ?? []),
                  );
                }
              }),
        ],
      ),
    );
  }
}

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
