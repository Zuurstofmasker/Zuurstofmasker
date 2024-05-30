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

  List<List<double>> get csvData => List<List<double>>.of([
        stateOutSeconds
            .map((e) => e.microsecondsSinceEpoch.toDouble())
            .toList(),
        stateOutFlow,
        biasSeconds.map((e) => e.microsecondsSinceEpoch.toDouble()).toList(),
        biasFlow,
        patientSeconds.map((e) => e.microsecondsSinceEpoch.toDouble()).toList(),
        patientFlow,
        fiO2Seconds.map((e) => e.microsecondsSinceEpoch.toDouble()).toList(),
        fiO2Flow,
        vtiSeconds.map((e) => e.microsecondsSinceEpoch.toDouble()).toList(),
        vtiFlow,
        vteSeconds.map((e) => e.microsecondsSinceEpoch.toDouble()).toList(),
        vteFlow
      ]);

  Future<SessionSerialData> fromFile(String sessionId) async {
    final List<List<String>> csvData =
        await csvFromFile("$sessionPath$sessionId/recordedData.csv");

    List<DateTime> CSVstateOutSeconds = [];
    List<double> CSVstateOutFlow = [];
    List<DateTime> CSVbiasSeconds = [];
    List<double> CSVbiasFlow = [];
    List<DateTime> CSVpatientSeconds = [];
    List<double> CSVpatientFlow = [];
    List<DateTime> CSVfiO2Seconds = [];
    List<double> CSVfiO2Flow = [];
    List<DateTime> CSVvtiSeconds = [];
    List<double> CSVvtiFlow = [];
    List<DateTime> CSVvteSeconds = [];
    List<double> CSVvteFlow = [];
    List<DateTime> CSVspO2Seconds = [];
    List<double> CSVspO2Flow = [];

    late List<List<double>> CSVvalueLists = [
      CSVstateOutFlow,
      CSVbiasFlow,
      CSVpatientFlow,
      CSVfiO2Flow,
      CSVvtiFlow,
      CSVvteFlow,
      CSVspO2Flow
    ];

    late List<List<DateTime>> CSVtimestampsLists = [
      CSVstateOutSeconds,
      CSVbiasSeconds,
      CSVpatientSeconds,
      CSVfiO2Seconds,
      CSVvtiSeconds,
      CSVvteSeconds,
      CSVspO2Seconds
    ];

    for (List<String> csvRow in csvData) {
      for (int i = 0; i < timestampsLists.length; i = i + 2) {
        CSVtimestampsLists[i].add(DateTime.tryParse(csvRow[i]) ??
            DateTime.fromMicrosecondsSinceEpoch(0));
      }
      for (int i = 1; i < valueLists.length; i = i + 2) {
        CSVvalueLists[i].add(double.tryParse(csvRow[i]) ?? 0.0);
      }
    }

    return SessionSerialData(
      sessionId: sessionId,
      stateOutSeconds: CSVstateOutSeconds,
      stateOutFlow: CSVstateOutFlow,
      biasSeconds: CSVbiasSeconds,
      biasFlow: CSVbiasFlow,
      patientSeconds: CSVpatientSeconds,
      patientFlow: CSVpatientFlow,
      fiO2Seconds: CSVfiO2Seconds,
      fiO2Flow: CSVfiO2Flow,
      vtiSeconds: CSVvtiSeconds,
      vtiFlow: CSVvtiFlow,
      vteSeconds: CSVvteSeconds,
      vteFlow: CSVvteFlow,
      spO2Flow: CSVspO2Flow,
      spO2Seconds: CSVspO2Seconds,
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
