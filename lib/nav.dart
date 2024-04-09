import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Dashborad/main.dart';
import 'package:zuurstofmasker/main.dart';

void main() async {
  runApp(const MyNavBar());
}

class MyNavBar extends StatelessWidget {
  const MyNavBar({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          leadingWidth: 250,
          leading: Container(
            height: double.infinity,
            color: Colors.blue,
            width: 250,
            child: const Center(
              child: Text(
                'Add logo nav',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
          ),
        ),
        body: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blue,
              width: 250,
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Button(
                          text: 'Opvang',
                          icon: Icons.home,
                          selected: true,
                        ),
                        SizedBox(height: 10),
                        Button(
                          text: 'Geschiedenis',
                          icon: Icons.list,
                        ),
                        SizedBox(height: 10),
                        Button(
                          text: 'Instellingen',
                          icon: Icons.settings,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;

  const Button({
    super.key,
    required this.icon,
    required this.text,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        iconColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            5,
          ),
        )),
        backgroundColor: MaterialStateProperty.all(
          selected ? Colors.white.withAlpha(50) : Colors.blue,
        ),
      ),
      // onPressed: onPressed,
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const MyMainPage()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 15,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
