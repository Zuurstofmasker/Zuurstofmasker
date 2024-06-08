import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/config.dart';

class SessionSerialData {
  SessionSerialData({
    required this.sessionId,
    required this.pressureDateTime,
    required this.pressureData,
    required this.flowDateTime,
    required this.flowData,
    required this.tidalVolumeDateTime,
    required this.tidalVolumeData,
    required this.fiO2DateTime,
    required this.fiO2Data,
    required this.sp02DateTime,
    required this.sp02Data,
    required this.pulseDateTime,
    required this.pulseData,
    required this.leakDateTime,
    required this.leakData,
  });

  final String sessionId;
  final List<DateTime> pressureDateTime;
  final List<double> pressureData;
  final List<DateTime> flowDateTime;
  final List<double> flowData;
  final List<DateTime> tidalVolumeDateTime;
  final List<double> tidalVolumeData;
  final List<DateTime> fiO2DateTime;
  final List<double> fiO2Data;
  final List<DateTime> sp02DateTime;
  final List<double> sp02Data;
  final List<DateTime> pulseDateTime;
  final List<double> pulseData;
  final List<DateTime> leakDateTime;
  final List<double> leakData;

  late List<List<double>> valueLists = [
    pressureData,
    flowData,
    tidalVolumeData,
    fiO2Data,
    sp02Data,
    pulseData,
    leakData
  ];

  late List<List<DateTime>> timestampsLists = [
    pressureDateTime,
    flowDateTime,
    tidalVolumeDateTime,
    fiO2DateTime,
    sp02DateTime,
    pulseDateTime,
    leakDateTime
  ];

  static Future<SessionSerialData> fromFile(String sessionId) async {
    final List<List<dynamic>> csvData =
        await csvFromFile<dynamic>("$sessionPath$sessionId/recordedData.csv");

    final List<List<double>> csvValueLists = List.generate(7, (_) => []);
    final List<List<DateTime>> csvTimestampsLists = List.generate(7, (_) => []);

    for (List<dynamic> csvRow in csvData.skip(1)) {
      for (int i = 0; i < csvTimestampsLists.length; i++) {
        final int index = i * 2;
        if (csvRow[index] == "" || csvRow[index + 1] == "") break;

        String time = csvRow[index].toString();
        String value = csvRow[index + 1].toString();

        csvTimestampsLists[i]
            .add(DateTime.fromMillisecondsSinceEpoch(int.tryParse(time) ?? 0));
        csvValueLists[i].add(double.tryParse(value) ?? 0.0);
      }
    }

    return SessionSerialData(
      sessionId: sessionId,
      pressureDateTime: csvTimestampsLists[0],
      pressureData: csvValueLists[0],
      flowDateTime: csvTimestampsLists[1],
      flowData: csvValueLists[1],
      tidalVolumeDateTime: csvTimestampsLists[2],
      tidalVolumeData: csvValueLists[2],
      fiO2DateTime: csvTimestampsLists[3],
      fiO2Data: csvValueLists[3],
      sp02DateTime: csvTimestampsLists[4],
      sp02Data: csvValueLists[4],
      pulseDateTime: csvTimestampsLists[5],
      pulseData: csvValueLists[5],
      leakDateTime: csvTimestampsLists[6],
      leakData: csvValueLists[6],
    );
  }

  Future<File> saveToFile(String sessionId) async {
    // Setting the titles of the csv
    final List<List<String>> csvData = [
      [
        "pressureDateTime",
        "pressureData",
        "flowDateTime",
        "flowData",
        "tidalVolumeDateTime",
        "tidalVolumeData",
        "fiO2DateTime",
        "fiO2Data",
        "sp02DateTime",
        "sp02Data",
        "pulseDateTime",
        "pulseData",
        "leakDateTime",
        "leakData"
      ]
    ];

    // Get item with most values
    int maxValue = timestampsLists.map((list) => list.length).reduce(max);
    // Helper function to safely get a value or a default if out of bounds
    String safeGetValue<T>(
        List<T> list, int index, String Function(T) toString) {
      if (index < list.length) {
        return toString(list[index]);
      }
      return '';
    }

    // Loop through all items and add the corresponding value to csv list
    for (int i = 0; i < maxValue; i++) {
      final List<String> row = [];
      for (int j = 0; j < timestampsLists.length; j++) {
        row.add(safeGetValue(timestampsLists[j], i,
            (v) => v.millisecondsSinceEpoch.toString()));
        row.add(safeGetValue(valueLists[j], i, (v) => v.toString()));
      }
      csvData.add(row);
    }

    // Saving the data to the file
    return await csvToFile(csvData, "$sessionPath$sessionId/recordedData.csv");
  }
}
