import 'dart:async';
import 'dart:io';

import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/config.dart';

class SessionSerialData {
  const SessionSerialData({
    required this.sessionId,
    required this.seconds,
    required this.stateOutFlow,
    required this.biasFlow,
    required this.patientFlow,
    required this.fiO2,
    required this.vti,
    required this.vte,
  });

  final String sessionId;
  final List<DateTime> seconds;
  final List<double> stateOutFlow;
  final List<double> biasFlow;
  final List<double> patientFlow;
  final List<double> fiO2;
  final List<double> vti;
  final List<double> vte;

  List<List<double>> get csvData => List<List<double>>.of([
        seconds.map((e) => e.microsecondsSinceEpoch.toDouble()).toList(),
        stateOutFlow,
        biasFlow,
        patientFlow,
        fiO2,
        vti,
        vte
      ]);

  Future<SessionSerialData> fromFile(String sessionId) async {
    final List<List<String>> csvData =
        await csvFromFile("$sessionPath$sessionId/recordedData.csv");

    return SessionSerialData(
      sessionId: sessionId,
      seconds: csvData[0]
          .skip(1)
          .map((e) => DateTime.fromMillisecondsSinceEpoch(int.parse(e)))
          .toList(),
      stateOutFlow: csvData[1].skip(1).map((e) => double.parse(e)).toList(),
      biasFlow: csvData[2].skip(1).map((e) => double.parse(e)).toList(),
      patientFlow: csvData[3].skip(1).map((e) => double.parse(e)).toList(),
      fiO2: csvData[4].skip(1).map((e) => double.parse(e)).toList(),
      vti: csvData[5].skip(1).map((e) => double.parse(e)).toList(),
      vte: csvData[6].skip(1).map((e) => double.parse(e)).toList(),
    );
  }

  Future<File> saveToFile(String sessionId) async {
    // Setting the titles of the csv
    final List<List<String>> csvData = [
      ["time"],
      ["stateOutFlow"],
      ["biasFlow"],
      ["patientFlow"],
      ["fiO2"],
      ["vti"],
      ["vte"]
    ];

    // converting the data to strings
    csvData[0].addAll(seconds.map((e) => e.millisecondsSinceEpoch.toString()));
    csvData[1].addAll(stateOutFlow.map((e) => e.toString()));
    csvData[2].addAll(biasFlow.map((e) => e.toString()));
    csvData[3].addAll(patientFlow.map((e) => e.toString()));
    csvData[4].addAll(fiO2.map((e) => e.toString()));
    csvData[5].addAll(vti.map((e) => e.toString()));
    csvData[6].addAll(vte.map((e) => e.toString()));

    // Saving the data to the file
    return await csvToFile(csvData, "$sessionPath$sessionId/recordedData.csv");
  }

  // void AddSecond(double increment) {
  //   seconds.add(seconds.last + increment);
  // }
}
