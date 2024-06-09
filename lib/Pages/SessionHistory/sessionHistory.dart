import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Models/sessionSerialData.dart';
import 'package:zuurstofmasker/Models/sorting.dart';
import 'package:zuurstofmasker/Pages/SessionDetails/sessionDetails.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/titles.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';

// ignore: must_be_immutable
class SessionHistory extends StatelessWidget {
  SessionHistory({super.key});

  final ValueNotifier<String> searchValueNotifier = ValueNotifier<String>('');
  // First value is the column index, second value is the sorting order
  final SortingState tableSorting =
      SortingState(sortColumn: 1, isAscending: false);

  // Some date filter fields
  DateTime? startDate;
  DateTime? endDate;
  bool get isDateFilterActive => startDate != null && endDate != null;

  void searchTable(String? value) {
    searchValueNotifier.value = value ?? '';
  }

  // A simle function that filters the sessions based on the search value on each column
  List<Session> filterSessions(List<Session> sessions, String searchValue) {
    if (searchValue.isEmpty) return sessions;

    List<String> searchKeys = searchValue.toLowerCase().split(' ');
    return sessions.where((session) {
      // Testing all the values in the tale on the search keys
      for (String key in searchKeys) {
        if (key.isEmpty) continue;

        if (session.id.toString().toLowerCase().contains(key) ||
            session.birthDateTime.toString().toLowerCase().contains(key) ||
            session.nameMother.toLowerCase().contains(key) ||
            session.note.toLowerCase().contains(key)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  // A simple function that sorts the sessions based on the selected column
  List<Session> sortSessions(List<Session> sessions) {
    if (tableSorting.sortColumn == 0) {
      sessions.sort((a, b) => a.id.compareTo(b.id));
    } else if (tableSorting.sortColumn == 1) {
      sessions.sort((a, b) => a.birthDateTime.compareTo(b.birthDateTime));
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

  Future<DateTime?> pickDate(BuildContext context,
      [String? title, DateTime? startDate]) async {
    return await showDatePicker(
      locale: locale,
      helpText: title ?? 'Kies een datum',
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2024),
      lastDate: DateTime(2100),
    );
  }

  List<Session> filterRange(List<Session> sessions) {
    if (!isDateFilterActive) return sessions;

    return sessions.where((session) {
      // Getting only the date part and removing the time part
      final DateTime birthTime = DateUtils.dateOnly(session.birthDateTime);
      return !birthTime.isBefore(startDate!) && !birthTime.isAfter(endDate!);
    }).toList();
  }

  Future<void> setRange(BuildContext context) async {
    startDate = await pickDate(context, 'Startdatum');
    if (startDate == null) return;
    endDate = await pickDate(context, 'Einddatum', startDate);
    if (endDate == null) return;
    searchValueNotifier.notifyListeners();
  }

  void removeRange() {
    startDate = null;
    endDate = null;
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
              children: [
                const PageTitle(title: 'Sessie geschiedenis'),
                const Spacer(),
                ValueListenableBuilder(
                    valueListenable: searchValueNotifier,
                    builder: (context, value, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Button(
                            text: 'Zoeken in periode',
                            onTap: () async => await setRange(context),
                            icon: Icons.date_range,
                          ),
                          if (isDateFilterActive) ...[
                            const PaddingSpacing(),
                            Button(
                              color: dangerColor,
                              text: 'Verwijder filter',
                              onTap: removeRange,
                              icon: Icons.clear,
                            )
                          ]
                        ],
                      );
                    }),
                const PaddingSpacing(),
                SizedBox(
                  width: 300,
                  child: InputField(
                    hintText: 'Zoeken',
                    icon: Icons.search,
                    onChange: searchTable,
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
                              'Opvangkamer',
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
                                filterRange(
                                  filterSessions(sessions, value),
                                ),
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
      color: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return primaryColor.withOpacity(0.2);
        }

        return null;
      }),
      onSelectChanged: (value) async {
        final SessionSerialData serialData =
            await SessionSerialData.fromFile(session.id);
        pushPage(
          MaterialPageRoute(
            builder: (context) => SessionDetails(
              session: session,
              serialData: serialData,
            ),
          ),
        );
      },
      cells: <DataCell>[
        DataCell(Text("Opvangkamer ${session.roomNumber}")),
        DataCell(Text(session.birthDateTime.toString())),
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
