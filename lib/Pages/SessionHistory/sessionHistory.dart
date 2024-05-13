import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Models/sorting.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/titles.dart';
import 'package:zuurstofmasker/config.dart';

class SessionHistory extends StatelessWidget {
  SessionHistory({super.key});

  final ValueNotifier<String> searchValueNotifier = ValueNotifier<String>('');
  // First value is the column index, second value is the sorting order
  final SortingState tableSorting =
      SortingState(sortColumn: 1, isAscending: false);

  void searchTable(String? value) {
    searchValueNotifier.value = value ?? '';
  }

  List<Session> filterSessions(List<Session> sessions, String searchValue) {
    if (searchValue.isEmpty) return sessions;

    List<String> searchKeys = searchValue.toLowerCase().split(' ');

    return sessions.where((session) {
      // Testing all the values in the tale on the search keys
      for (String key in searchKeys) {
        if (key.isEmpty) continue;

        if (session.id.toString().toLowerCase().contains(key) ||
            session.birthTime.toString().toLowerCase().contains(key) ||
            session.nameMother.toLowerCase().contains(key) ||
            session.note.toLowerCase().contains(key)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  List<Session> sortSessions(List<Session> sessions) {
    if (tableSorting.sortColumn == 0) {
      sessions.sort((a, b) => a.id.compareTo(b.id));
    } else if (tableSorting.sortColumn == 1) {
      sessions.sort((a, b) => a.birthTime.compareTo(b.birthTime));
    } else if (tableSorting.sortColumn == 2) {
      sessions.sort((a, b) => a.nameMother.compareTo(b.nameMother));
    } else if (tableSorting.sortColumn == 3) {
      sessions.sort((a, b) => a.note.compareTo(b.note));
    }

    if (!tableSorting.isAscending) {
      sessions = sessions.reversed.toList();
    }

    return sessions;
  }

  void updateSorting(int index) {
    if (tableSorting.sortColumn == index) {
      tableSorting.isAscending = !tableSorting.isAscending;
    } else {
      tableSorting.sortColumn = index;
      tableSorting.isAscending = false;
    }

    searchValueNotifier.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Nav(
      child: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const PageTitle(title: 'Sessie geschiedenis'),
                SizedBox(
                  width: 300,
                  child: Flexible(
                    child: InputField(
                      hintText: 'Zoeken',
                      icon: Icons.search,
                      onChange: searchTable,
                    ),
                  ),
                )
              ],
            ),
            const PaddingSpacing(multiplier: 2),
            Flexible(
              child: FutureBuilder(
                future: getSessions(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const SizedBox();
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    List<Session> sessions = snapshot.data ?? [];
                    return ValueListenableBuilder(
                      valueListenable: searchValueNotifier,
                      builder: (context, value, child) {
                        return SingleChildScrollView(
                          child: DataTable(
                            showCheckboxColumn: false,
                            border: TableBorder.all(borderRadius: borderRadius),
                            headingRowHeight: 40,
                            columns: ([
                              'ID',
                              'Geboorte datum',
                              'Naam moeder',
                              'Opmerking'
                            ]
                                .asMap()
                                .entries
                                .map((entry) => sessionHistoryTitleCell(
                                      title: entry.value,
                                      index: entry.key,
                                      tableSorting: tableSorting,
                                      onTap: updateSorting,
                                    ))
                                .toList()),
                            rows: getSessionHistoryItems(
                              sortSessions(
                                filterSessions(sessions, value),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<DataRow> getSessionHistoryItems(List<Session> sessions) {
  List<DataRow> items = [];
  for (var session in sessions) {
    var row = DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return primaryColor.withOpacity(0.2);
        }

        return null;
      }),
      onSelectChanged: (value) {
        // TODO: Add navigation to the session details
      },
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

DataColumn sessionHistoryTitleCell({
  required String title,
  required int index,
  required SortingState tableSorting,
  required Function(int index) onTap,
}) {
  return DataColumn(
    label: Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            if (tableSorting.sortColumn == index)
              tableSorting.isAscending
                  ? const Icon(Icons.arrow_drop_down)
                  : const Icon(Icons.arrow_drop_up)
          ],
        ),
      ),
    ),
  );
}
