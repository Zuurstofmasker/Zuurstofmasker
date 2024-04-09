import 'package:flutter/material.dart';
import 'package:zuurstofmasker/TestPage.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/mainold.dart';

void main() {
  // Setting the default styles for the popups

  runApp(Maasgroep18App());
}

class Maasgroep18App extends StatelessWidget {
  Maasgroep18App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Maasgroep 18 Applicatie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: "Dit is ook een title",
      ),
    );
  }
}
