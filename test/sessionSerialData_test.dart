import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Models/sessionSerialData.dart';
import 'package:zuurstofmasker/config.dart';

void main() {
  // Hulpfuncties voor het instellen van testbestanden en directories
  Future<String> createTempDir(String prefix) async {
    final tempDir = await Directory.systemTemp.createTemp(prefix);
    return tempDir.path;
  }

  group('SessionSerialData', () {
    test('saveToFile should create correct CSV file', () async {
      // Create a SessionSerialData object
      var tempDir1 = await createTempDir("1111");
      sessionPath = "$tempDir1\\";

      final sessionData = SessionSerialData(
        sessionId: 'test',
        pressureDateTime: [
          DateTime.fromMillisecondsSinceEpoch(1640995200000),
          DateTime.fromMillisecondsSinceEpoch(1640995260000)
        ],
        pressureData: [1.0, 2.0],
        flowDateTime: [],
        fiO2Data: [],
        fiO2DateTime: [],
        flowData: [],
        leakData: [],
        leakDateTime: [],
        pulseData: [],
        pulseDateTime: [],
        sp02Data: [],
        sp02DateTime: [],
        tidalVolumeData: [],
        tidalVolumeDateTime: [],
      );
      createFolder("${sessionPath}0");
      // Use the saveToFile method to create a CSV file
      var file = await sessionData.saveToFile("0");

      // Check that the CSV file has the correct data
      final fileContent = await file.readAsString();
      expect(
          fileContent,
          equals(
              'pressureDateTime,pressureData,flowDateTime,flowData,tidalVolumeDateTime,tidalVolumeData,fiO2DateTime,fiO2Data,sp02DateTime,sp02Data,pulseDateTime,pulseData,leakDateTime,leakData\r\n'
              '1640995200000,1.0,,,,,,,,,,,,\r\n'
              '1640995260000,2.0,,,,,,,,,,,,'));

      // Delete the temporary file

      var sessionData2 = await SessionSerialData.fromFile('0');

      // Check that the SessionSerialData object has the correct data
      expect(
          sessionData2.pressureDateTime,
          equals([
            DateTime.fromMillisecondsSinceEpoch(1640995200000),
            DateTime.fromMillisecondsSinceEpoch(1640995260000)
          ]));
      expect(sessionData2.pressureData, equals([1.0, 2.0]));

      await file.delete();
    });
  });
}
