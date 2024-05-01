import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/config.dart';

class Settings {
  String passwordHash;
  final SettingColors colors;
  final SettingLimits limits;

  Settings({
    required this.passwordHash,
    required this.colors,
    required this.limits,
  });

  Future<File> updateSettingsToFile() async =>
      writeGenericToFile(this, settingsPath);

  static Future<Settings> getSettingsFromFile() async =>
      await getGenericFromFile(settingsPath, Settings.fromJson);

  static String hashPassword(String password) =>
      hmacSha256.convert(utf8.encode(password)).toString();

  String setPassword(String password) => passwordHash = hashPassword(password);

  bool comparePassword(String password) =>
      passwordHash == hmacSha256.convert(utf8.encode(password)).toString()
          ? true
          : false;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        passwordHash: json['passwordHash'],
        colors: SettingColors.fromJson(json['colors']),
        limits: SettingLimits.fromJson(json['limits']),
      );

  Map<String, dynamic> toJson() => {
        'passwordHash': passwordHash,
        'colors': colors.toJson(),
        'limits': limits.toJson(),
      };
}

class SettingColors {
  Color spO2;
  Color pulse;
  Color fiO2;
  Color leak;
  Color pressure;
  Color flow;
  Color tidalVolume;
  Color limitValues;

  SettingColors({
    required this.spO2,
    required this.pulse,
    required this.fiO2,
    required this.leak,
    required this.pressure,
    required this.flow,
    required this.tidalVolume,
    required this.limitValues,
  });

  factory SettingColors.fromJson(Map<String, dynamic> json) => SettingColors(
        spO2: Color(json['spO2']),
        pulse: Color(json['pulse']),
        fiO2: Color(json['fiO2']),
        leak: Color(json['leak']),
        pressure: Color(json['pressure']),
        flow: Color(json['flow']),
        tidalVolume: Color(json['tidalVolume']),
        limitValues: Color(json['limitValues']),
      );

  Map<String, dynamic> toJson() => {
        'spO2': spO2.value,
        'pulse': pulse.value,
        'fiO2': fiO2.value,
        'leak': leak.value,
        'pressure': pressure.value,
        'flow': flow.value,
        'tidalVolume': tidalVolume.value,
        'limitValues': limitValues.value,
      };
}

class SettingLimits {
  int lowPulse;
  int cprPulse;

  LimitType spO2;
  LimitType cSrO2;
  LimitType cFTOE;

  SettingLimits({
    required this.lowPulse,
    required this.cprPulse,
    required this.spO2,
    required this.cSrO2,
    required this.cFTOE,
  });

  factory SettingLimits.fromJson(Map<String, dynamic> json) => SettingLimits(
        lowPulse: json['lowPulse'],
        cprPulse: json['cprPulse'],
        spO2: LimitType.values[json['spO2']],
        cSrO2: LimitType.values[json['cSrO2']],
        cFTOE: LimitType.values[json['cFTOE']],
      );

  Map<String, dynamic> toJson() => {
        'lowPulse': lowPulse,
        'cprPulse': cprPulse,
        'spO2': spO2.index,
        'cSrO2': cSrO2.index,
        'cFTOE': cFTOE.index,
      };
}

enum LimitType { AHA, ARC, ERC, TenToFiftyDawson, TenToNinetyDawson, Custom }
