import 'dart:convert';
import 'dart:typed_data';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

// Navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Path to the json files
const String sessionPath = 'Data/Sessions/';
const String sessionsJsonPath = '${sessionPath}sessions.json';
const String settingsPath = 'Data/Settings/';
const String settingsJsonPath = '${settingsPath}settings.json';


//Colors
const Color primaryColor = Color(0xff86d1ed);
const Color secondaryColor = Color(0xff181c74);
const Color greyTextColor = Color(0xff8a8a8a);
const Color dangerColor = Color(0xffe74c3c);
const Color successColor = Color(0xff2ecc71);

// Border radius
const double borderRadiusSize = 8;
const BorderRadius borderRadius =
    BorderRadius.all(Radius.circular(borderRadiusSize));

// Input styles
const OutlineInputBorder inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: secondaryColor), borderRadius: borderRadius);

// Padding
const double pagePaddingSize = 30;
const EdgeInsets pagePadding = EdgeInsets.all(pagePaddingSize);

const double mainPaddingSize = 15;
const EdgeInsets mainPadding = EdgeInsets.all(mainPaddingSize);

// Password hashing
final Uint8List encryptionKey = utf8.encode('My32CharacterEncryptionKey!');
final Hmac hmacSha256 = Hmac(sha256, encryptionKey);

// Camera settings
const int cameraIndex = 0;
const Duration maxVideoDuration = Duration(minutes: 45);
const MediaSettings cameraSettings = MediaSettings(
  resolutionPreset: ResolutionPreset.medium,
  enableAudio: true,
);
