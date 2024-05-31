import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/config.dart';

class SessionSerialData {
  SessionSerialData({
    required this.sessionId,
    required this.stateOutSeconds,
    required this.stateOutFlow,
    required this.biasSeconds,
    required this.biasFlow,
    required this.patientSeconds,
    required this.patientFlow,
    required this.fiO2Seconds,
    required this.fiO2Flow,
    required this.vtiSeconds,
    required this.vtiFlow,
    required this.vteSeconds,
    required this.vteFlow,
    required this.spO2Seconds,
    required this.spO2Flow,
  });

  final String sessionId;
  final List<DateTime> stateOutSeconds;
  final List<double> stateOutFlow;
  final List<DateTime> biasSeconds;
  final List<double> biasFlow;
  final List<DateTime> patientSeconds;
  final List<double> patientFlow;
  final List<DateTime> fiO2Seconds;
  final List<double> fiO2Flow;
  final List<DateTime> vtiSeconds;
  final List<double> vtiFlow;
  final List<DateTime> vteSeconds;
  final List<double> vteFlow;
  final List<DateTime> spO2Seconds;
  final List<double> spO2Flow;

  late List<List<double>> valueLists = [
    stateOutFlow,
    biasFlow,
    patientFlow,
    fiO2Flow,
    vtiFlow,
    vteFlow,
    spO2Flow
  ];

  late List<List<DateTime>> timestampsLists = [
    stateOutSeconds,
    biasSeconds,
    patientSeconds,
    fiO2Seconds,
    vtiSeconds,
    vteSeconds,
    spO2Seconds
  ];

  List<List<double>> get csvData {
    List<List<double>> csvData = [];
    for (int i = 0; i < valueLists.length; i++) {
      csvData.add(valueLists[i]);
      csvData.add(timestampsLists[i]
          .map((e) => e.microsecondsSinceEpoch.toDouble())
          .toList());
    }
    return csvData;
  }

  static Future<SessionSerialData> fromFile(String sessionId) async {
    final List<List<String>> csvData =
        await csvFromFile("$sessionPath$sessionId/recordedData.csv");

    final List<List<double>> csvValueLists = List.generate(6, (_) => []);
    final List<List<DateTime>> csvTimestampsLists = List.generate(6, (_) => []);

    for (List<String> csvRow in csvData) {
      for (int i = 0; i < csvTimestampsLists.length; i += 2) {
        csvTimestampsLists[i].add(DateTime.tryParse(csvRow[i]) ??
            DateTime.fromMicrosecondsSinceEpoch(0));
        csvValueLists[i + 1].add(double.tryParse(csvRow[i]) ?? 0.0);
      }
    }

    return SessionSerialData(
      sessionId: sessionId,
      stateOutSeconds: csvTimestampsLists[0],
      stateOutFlow: csvValueLists[0],
      biasSeconds: csvTimestampsLists[1],
      biasFlow: csvValueLists[1],
      patientSeconds: csvTimestampsLists[2],
      patientFlow: csvValueLists[2],
      fiO2Seconds: csvTimestampsLists[3],
      fiO2Flow: csvValueLists[3],
      vtiSeconds: csvTimestampsLists[4],
      vtiFlow: csvValueLists[4],
      vteSeconds: csvTimestampsLists[5],
      vteFlow: csvValueLists[5],
      spO2Seconds: csvTimestampsLists[6],
      spO2Flow: csvValueLists[6],
    );
  }

  Future<File> saveToFile(String sessionId) async {
    // Setting the titles of the csv
    final List<List<String>> csvData = [
      [
        "stateOut time",
        "stateOutFlow",
        "bias time",
        "biasFlow",
        "patient time",
        "patientFlow",
        "fiO2 time",
        "fiO2",
        "vti time",
        "vti",
        "vte time",
        "vte",
        "spO2 time",
        "spO2"
      ]
    ];

    // Get item with most values
    int maxValue = timestampsLists.map((list) => list.length).reduce(max);
    // Helper function to safely get a value or a default if out of bounds
    String safeGetValue<T>(
        List<T?> list, int index, String Function(T?) toString) {
      if (index < list.length) {
        return toString(list[index]);
      }
      return '';
    }

    // Loop through all items and add the corresponding value to csv list
    for (int i = 0; i < maxValue; i++) {
      List<String> row = [];
      for (int j = 0; j < timestampsLists.length; j++) {
        row.add(safeGetValue(timestampsLists[j], i,
            (v) => v?.millisecondsSinceEpoch.toString() ?? ''));
        row.add(safeGetValue(valueLists[j], i, (v) => v?.toString() ?? ''));
      }
      csvData.add(row);
    }

    // Saving the data to the file
    return await csvToFile(csvData, "$sessionPath$sessionId/recordedData.csv");
  }
}
