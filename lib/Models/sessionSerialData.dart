import 'dart:async';
import 'dart:io';

import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/config.dart';

class SessionSerialData {
  const SessionSerialData({
    required this.sessionId,
    required this.stateOutSeconds,
    required this.stateOutFlow,
    required this.biasSeconds,
    required this.biasFlow,
    required this.patientSeconds,
    required this.patientFlow,
    required this.fiO2Seconds,
    required this.fiO2,
    required this.vtiSeconds,
    required this.vti,
    required this.vteSeconds,
    required this.vte,
  });

  final String sessionId;
  final List<DateTime> stateOutSeconds;
  final List<double> stateOutFlow;
  final List<DateTime> biasSeconds;
  final List<double> biasFlow;
  final List<DateTime> patientSeconds;
  final List<double> patientFlow;
  final List<DateTime> fiO2Seconds;
  final List<double> fiO2;
  final List<DateTime> vtiSeconds;
  final List<double> vti;
  final List<DateTime> vteSeconds;
  final List<double> vte;

  List<List<double>> get csvData => List<List<double>>.of([
        stateOutSeconds.map((e) => e.microsecondsSinceEpoch.toDouble()).toList(),
        stateOutFlow,
        biasSeconds.map((e) => e.microsecondsSinceEpoch.toDouble()).toList(),
        biasFlow,
        patientSeconds.map((e) => e.microsecondsSinceEpoch.toDouble()).toList(),
        patientFlow,
        fiO2Seconds.map((e) => e.microsecondsSinceEpoch.toDouble()).toList(),
        fiO2,
        vtiSeconds.map((e) => e.microsecondsSinceEpoch.toDouble()).toList(),
        vti,
        vteSeconds.map((e) => e.microsecondsSinceEpoch.toDouble()).toList(),
        vte
      ]);

  Future<SessionSerialData> fromFile(String sessionId) async {
    final List<List<String>> csvData =
        await csvFromFile("$sessionPath$sessionId/recordedData.csv");

    return SessionSerialData(
      sessionId: sessionId,
      stateOutSeconds: csvData[0]
          .skip(1)
          .map((e) => DateTime.fromMillisecondsSinceEpoch(int.parse(e)))
          .toList(),
      stateOutFlow: csvData[1].skip(1).map((e) => double.parse(e)).toList(),
      biasSeconds: csvData[2]
          .skip(1)
          .map((e) => DateTime.fromMillisecondsSinceEpoch(int.parse(e)))
          .toList(),
      biasFlow: csvData[3].skip(1).map((e) => double.parse(e)).toList(),
      patientSeconds: csvData[4]
          .skip(1)
          .map((e) => DateTime.fromMillisecondsSinceEpoch(int.parse(e)))
          .toList(),
      patientFlow: csvData[5].skip(1).map((e) => double.parse(e)).toList(),
      fiO2Seconds: csvData[6]
          .skip(1)
          .map((e) => DateTime.fromMillisecondsSinceEpoch(int.parse(e)))
          .toList(),
      fiO2: csvData[7].skip(1).map((e) => double.parse(e)).toList(),
      vtiSeconds: csvData[8]
          .skip(1)
          .map((e) => DateTime.fromMillisecondsSinceEpoch(int.parse(e)))
          .toList(),
      vti: csvData[9].skip(1).map((e) => double.parse(e)).toList(),
      vteSeconds: csvData[10]
          .skip(1)
          .map((e) => DateTime.fromMillisecondsSinceEpoch(int.parse(e)))
          .toList(),
      vte: csvData[11].skip(1).map((e) => double.parse(e)).toList(),
    );
  }

  Future<File> saveToFile(String sessionId) async {
    // Setting the titles of the csv
    final List<List<String>> csvData = [
      ["stateOut time"],
      ["stateOutFlow"],
      ["bias time"],
      ["biasFlow"],
      ["patient time"],
      ["patientFlow"],
      ["fiO2 time"],
      ["fiO2"],
      ["vti time"],
      ["vti"],
      ["vte time"],
      ["vte"]
    ];

    // converting the data to strings
    csvData[0].addAll(stateOutSeconds.map((e) => e.millisecondsSinceEpoch.toString()));
    csvData[1].addAll(stateOutFlow.map((e) => e.toString()));
    csvData[2].addAll(biasSeconds.map((e) => e.millisecondsSinceEpoch.toString()));
    csvData[3].addAll(biasFlow.map((e) => e.toString()));
    csvData[4].addAll(patientSeconds.map((e) => e.millisecondsSinceEpoch.toString()));
    csvData[5].addAll(patientFlow.map((e) => e.toString()));
    csvData[6].addAll(fiO2Seconds.map((e) => e.millisecondsSinceEpoch.toString()));
    csvData[7].addAll(fiO2.map((e) => e.toString()));
    csvData[8].addAll(vtiSeconds.map((e) => e.millisecondsSinceEpoch.toString()));
    csvData[9].addAll(vti.map((e) => e.toString()));
    csvData[10].addAll(vteSeconds.map((e) => e.millisecondsSinceEpoch.toString()));
    csvData[11].addAll(vte.map((e) => e.toString()));

    // Saving the data to the file
    return await csvToFile(csvData, "$sessionPath$sessionId/recordedData.csv");
  }

  // void AddSecond(double increment) {
  //   seconds.add(seconds.last + increment);
  // }
}
