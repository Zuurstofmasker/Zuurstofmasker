import 'package:flutter/material.dart';

//Navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Path to the json files
const String sessionPath = 'Data/Sessions/';
const String sessionsJsonPath = '${sessionPath}sessions.json';
const String settingsPath = 'Data/Settings/settings.json';

//Colors
const Color primaryColor = Color(0xff86d1ed);
const Color secondaryColor = Color(0xff181c74);

const BorderRadius borderRadius = BorderRadius.all(Radius.circular(10));

//Input styles
const OutlineInputBorder inputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: secondaryColor),
  borderRadius: borderRadius
);
