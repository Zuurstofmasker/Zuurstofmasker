import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/sessionDetail.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';

class TerugKijken extends StatelessWidget {
  const TerugKijken();
  @override
  Widget build(BuildContext context) {
    return Nav(
      child: const SingleChildScrollView(
        child: Column(
          children: getTerugKijkItems(context),
        ),
      ),
    );
  }
}

class DataTableExample extends StatelessWidget {
  const DataTableExample({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSessions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox();
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'ID',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Naam moeder',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Opmerking',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
              rows: getTerugKijkItems(snapshot.data ?? []),
            );
          }
        });
  }
}

List<DataRow> getTerugKijkItems(List<SessionDetail> sessions) {
  List<DataRow> items = [];

  for (SessionDetail item in sessions) {
    items.add(Text("${item.id} ${item.nameMother}"));
  }
  return items;
}
