import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/sessionDetail.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';

class TerugKijken extends StatefulWidget {
  const TerugKijken({super.key});

  @override
  State<TerugKijken> createState() => _terugkijkenState();
}

List<SessionDetail> sessions = [];

class _terugkijkenState extends State<TerugKijken> {
  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Nav(
      child: SingleChildScrollView(
        child: const DataTableExample(),
      ),
    );
  }
}

class DataTableExample extends StatelessWidget {
  const DataTableExample({super.key});

  @override
  Widget build(BuildContext context) {
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
      rows: getTerugKijkItems(),
      //  const <DataRow>[
      //   DataRow(
      //     cells: <DataCell>[
      //       DataCell(Text('Sarah')),
      //       DataCell(Text('19')),
      //       DataCell(Text('Student')),
      //     ],
      //   ),
      //   DataRow(
      //     cells: <DataCell>[
      //       DataCell(Text('Janine')),
      //       DataCell(Text('43')),
      //       DataCell(Text('Professor')),
      //     ],
      //   ),
      //   DataRow(
      //     cells: <DataCell>[
      //       DataCell(Text('William')),
      //       DataCell(Text('27')),
      //       DataCell(Text('Associate Professor')),
      //     ],
      //   ),
      // ],
    );
  }
}

List<DataRow> getTerugKijkItems() {
  List<DataRow> items = [];

  for (SessionDetail item in sessions) {
    var row = DataRow(
      cells: <DataCell>[
        DataCell(Text(item.id.toString())),
        DataCell(Text(item.nameMother.toString())),
        DataCell(Text(item.note.toString())),
      ],
    );
    items.add(row);
  }
  return items;
}

void loadSessions() async {
  sessions = await getSessions();
  // createState(() {
  // sessions = sessions;
  // });
}
