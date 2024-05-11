import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zuurstofmasker/Models/settings.dart';
import 'package:zuurstofmasker/Models/user.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Helpers/jsonHelpers.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
import 'package:zuurstofmasker/config.dart';

void main() async {
  PopupAndLoading.baseStyle();

  await jsonAndFileHelperTests();

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

  await writeListToFile([User(age: 32, id: 2, name: 'Henk')], 'lib/test.json');
  print((await getListFromFile('lib/test.json', User.fromJson))[0].name);
  await appendItemToListFile(
      User(age: 52, id: 2, name: 'Chris'), 'lib/test.json', User.fromJson);
  print((await getItemInListFile(1, 'lib/test.json', User.fromJson)).age);
  await updateItemInListFile(
      User(age: 35, id: 2, name: 'Chris2'), 1, 'lib/test.json', User.fromJson);
  await deleteItemInListFile(0, 'lib/test.json', User.fromJson);
  await writeGenericToFile(
      User(age: 35, id: 2, name: 'Jhenk'), 'lib/test2.json');
  print((await getGenericFromFile('lib/test2.json', User.fromJson)).name);

  await deleteFile('lib/test.json');
  await deleteFile('lib/test2.json');

  print(genericToJson(User(age: 32, id: 2, name: '')));
  print(listToJson([User(age: 32, id: 2, name: 'Henk')]));
  print(genericToJson({'test': 2}));
  print(jsonToList('[1,3,5]'));
  print(jsonToList(
          '[{"age": 5, "id": 1, "name": "Henk"},{"age": 5, "id": 1, "name": "lol"}]',
          User.fromJson)[1]
      .name);
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
