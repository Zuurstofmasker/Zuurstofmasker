import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Models/settings.dart';

// Navigator key used for easy navigation wihtout the need of context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Settings settings = defaultSettings;
bool settingsFromFile = false;

// Path to the json files
const String sessionPath = 'Data/Sessions/';
const String sessionsJsonPath = '${sessionPath}sessions.json';
const String settingsPath = 'Data/Settings/';
const String settingsJsonPath = '${settingsPath}settings.json';

// Colors
const Color primaryColor = Color(0xff86d1ed);
const Color secondaryColor = Color(0xff181c74);
const Color greyTextColor = Color(0xff8a8a8a);
const Color dangerColor = Color(0xffe74c3c);
const Color successColor = Color(0xff2ecc71);

const double borderRadiusSize = 8;
const BorderRadius borderRadius = BorderRadius.all(Radius.circular(borderRadiusSize));

// Input styles
const OutlineInputBorder inputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: secondaryColor),
  borderRadius: borderRadius
);

// Some padding constants
const double pagePaddingSize = 30;
const EdgeInsets pagePadding = EdgeInsets.all(pagePaddingSize);

const double mainPaddingSize = 15;
const EdgeInsets mainPadding = EdgeInsets.all(mainPaddingSize);

// Used for the password encryption
final Uint8List encryptionKey = utf8.encode('My32CharacterEncryptionKey!');
final Hmac hmacSha256 = Hmac(sha256, encryptionKey);

// Default settings file for creating a file structure or reading the file went wrong
final Settings defaultSettings = Settings(
  passwordHash: Settings.hashPassword('test'),
  colors: SettingColors(
    spO2: Colors.red,
    pulse: Colors.blue,
    fiO2: Colors.green,
    leak: Colors.yellow,
    pressure: Colors.purple,
    flow: Colors.orange,
    tidalVolume: Colors.pink,
    limitValues: Colors.grey,
  ),
  limits: SettingLimits(
    lowPulse: 50,
    cprPulse: 100,
    spO2: LimitType.AHA,
    cSrO2: LimitType.ERC,
    cFTOE: LimitType.TenToFiftyDawson,
  ),
);

