import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zuurstofmasker/Models/settings.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
import 'package:zuurstofmasker/config.dart';

void main() async {
  PopupAndLoading.baseStyle();

  await setupFileStructure();

  runApp(App(home: (context) => const Dashboard()));
}

Future<void> jsonAndFileHelperTests() async {
  Settings settings = await getGenericFromFile(settingsPath, Settings.fromJson);

  settings.comparePassword('test')
      ? print('Password correct')
      : print('Password incorrect');
  // print all settings of the settings object
  print(settings.passwordHash);
  print(settings.colors.spO2);
  print(settings.colors.pulse);
  print(settings.colors.fiO2);
  print(settings.colors.leak);
  print(settings.colors.pressure);
  print(settings.colors.flow);
  print(settings.colors.tidalVolume);
  print(settings.colors.limitValues);
  print(settings.limits.lowPulse);
  print(settings.limits.cprPulse);
  print(settings.limits.spO2);
  print(settings.limits.cSrO2);
  print(settings.limits.cFTOE);

Future<void> setupFileStructure() async {
  // Checking for settings file
  if (!await doesFolderOrFileExist(settingsJsonPath)) {
    // Creating the missing file and folders
    await createFile(settingsJsonPath, true);


    // Creating a defualt settings file
    await writeGenericToFile(
      Settings(
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
      ),
      settingsJsonPath,
    );
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
      title: 'Maasgroep 18 Applicatie',
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: home(context),
    );
  }
}
