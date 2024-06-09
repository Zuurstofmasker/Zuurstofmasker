import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zuurstofmasker/Models/settings.dart';
import 'package:zuurstofmasker/config.dart';

void main() {
  Future<String> createTempDir(String prefix) async {
    final tempDir = await Directory.systemTemp.createTemp(prefix);
    return tempDir.path;
  }

  group('Settings', () {
    test('getSettingsFromFile should create correct Settings', () async {
      var tempDir = await createTempDir('1');
      settingsJsonPath = '$tempDir\\settings.json';
      // Create a temporary file with some JSON data
      final file = await File(settingsJsonPath).writeAsString(
          '{"passwordHash":"5f4dcc3b5aa765d61d8327deb882cf99","colors":{"spO2":4293467747,"pulse":4278190080,"fiO2":4278190080,"leak":4280391411,"pressure":4278190080,"flow":4278190080,"tidalVolume":4278190080,"limitValues":4278190080},"limits":{"lowPulse":0,"cprPulse":0,"spO2":0,"cSrO2":0,"cFTOE":0}}');

      // Use the getSettingsFromFile method to create a Settings object
      final settings = await Settings.getSettingsFromFile();

      // Check that the Settings object has the correct data
      expect(settings.passwordHash, equals("5f4dcc3b5aa765d61d8327deb882cf99"));
      expect(settings.colors.fiO2.toHexString(),
          equals(Colors.black.toHexString()));
      expect(settings.colors.leak.toHexString(),
          equals(Colors.blue.toHexString()));
      expect(settings.limits.cFTOE, equals(LimitType.AHA));
      expect(settings.limits.cSrO2, equals(LimitType.AHA));

      // Delete the temporary file
      await file.delete();
    });

    test('updateSettingsToFile should create correct JSON file', () async {
      // Create a Settings object

      var tempDir = await createTempDir('2');
      settingsJsonPath = '$tempDir\\settings.json';

      final settings = Settings(
        passwordHash: "5f4dcc3b5aa765d61d8327deb882cf99",
        colors: SettingColors(
            spO2: Colors.pink,
            pulse: Colors.black,
            leak: Colors.blue,
            pressure: Colors.black,
            tidalVolume: Colors.black,
            fiO2: Colors.black,
            flow: Colors.black,
            limitValues: Colors.black),
        limits: SettingLimits(
            lowPulse: 0,
            cprPulse: 0,
            spO2: LimitType.AHA,
            cSrO2: LimitType.AHA,
            cFTOE: LimitType.AHA),
      );

      // Create a temporary file
      final file = File(settingsJsonPath);

      // Use the updateSettingsToFile method to create a JSON file
      await settings.updateSettingsToFile();

      // Check that the JSON file has the correct data
      final fileContent = await file.readAsString();
      expect(
          fileContent,
          equals(
              '{"passwordHash":"5f4dcc3b5aa765d61d8327deb882cf99","colors":{"spO2":4293467747,"pulse":4278190080,"fiO2":4278190080,"leak":4280391411,"pressure":4278190080,"flow":4278190080,"tidalVolume":4278190080,"limitValues":4278190080},"limits":{"lowPulse":0,"cprPulse":0,"spO2":0,"cSrO2":0,"cFTOE":0}}'));

      // Delete the temporary file
      await file.delete();
    });

    test('hashPassword, setPassword, and comparePassword should work correctly',
        () async {
      var tempDir = await createTempDir('3');
      settingsJsonPath = '$tempDir\\settings.json';
      // Create a Settings object
      final settings = Settings(
        passwordHash: "",
        colors: SettingColors(
            spO2: Colors.pink,
            pulse: Colors.black,
            leak: Colors.blue,
            pressure: Colors.black,
            tidalVolume: Colors.black,
            fiO2: Colors.black,
            flow: Colors.black,
            limitValues: Colors.black),
        limits: SettingLimits(
            lowPulse: 0,
            cprPulse: 0,
            spO2: LimitType.AHA,
            cSrO2: LimitType.AHA,
            cFTOE: LimitType.AHA),
      );

      // Set a password
      settings.setPassword("password");

      // Check that the password is hashed correctly
      expect(
          settings.passwordHash,
          equals(
              "360e23d82a9dec0ff0de035d77ecd3ea353883c235c648f9dc12fb14f9b6d24c"));

      // Check that the password can be compared correctly
      expect(settings.comparePassword("password"), equals(true));
      expect(settings.comparePassword("wrongpassword"), equals(false));
    });
  });
}
