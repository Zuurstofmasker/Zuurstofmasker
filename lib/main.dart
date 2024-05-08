import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zuurstofmasker/Models/settings.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
import 'package:zuurstofmasker/config.dart';

void main() async {
  PopupAndLoading.baseStyle();

  await setupFileStructure();
  await Settings.getSettingsFromFile().then((value) {
    settings = value;
    settingsFromFile = true;
  });

  runApp(App());
}

Future<void> setupFileStructure() async {
  // Checking for settings file
  if (!await doesFolderOrFileExist(settingsJsonPath)) {
    // Creating the missing file and folders
    await createFile(settingsJsonPath, true);

    // Creating a defualt settings file
    await writeGenericToFile(defaultSettings, settingsJsonPath);
  }

  // Checking for sessions file
  if (!await doesFolderOrFileExist(sessionsJsonPath)) {
    // Creating the missing file and folders
    await createFile(sessionsJsonPath, true);
    // Creating a defualt sessions file
    await writeListToFile([], sessionsJsonPath);
  }
}

class App extends StatelessWidget {
  App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Maasgroep 18 Applicatie',
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}
