import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:crypto/crypto.dart';

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

  static String hashPassword(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  String setPassword(String password) =>
      passwordHash = hashPassword(password);

  bool comparePassword(String password) =>
      passwordHash == sha256.convert(utf8.encode(password)).toString()
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
  final Color spO2;
  final Color pulse;
  final Color fiO2;
  final Color leak;
  final Color pressure;
  final Color flow;
  final Color tidalVolume;
  final Color limitValues;

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
  final int lowPulse;
  final int cprPulse;

  final LimitType spO2;
  final LimitType cSrO2;
  final LimitType cFTOE;

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
