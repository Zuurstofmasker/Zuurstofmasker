import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zuurstofmasker/Models/settings.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PopupAndLoading.baseStyle();

  await setupFileStructure();
  await Settings.getSettingsFromFile().then((value) {
    settings = value;
    settingsFromFile = true;
  });

  runApp(App(home: (context) => const Dashboard()));
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
  final Widget Function(BuildContext context) home;
  App({super.key, required this.home}) {
    routesStack.add(MaterialPageRoute(builder: home));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Zuurstofmasker',
      builder: EasyLoading.init(),
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [locale],
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: home(context),
    );
  }
}
