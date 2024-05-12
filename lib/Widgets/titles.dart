import 'package:flutter/material.dart';
import 'package:zuurstofmasker/config.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({super.key, required this.title, this.fontSize = 24});
  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: secondaryColor,
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  const SubTitle({super.key, required this.title, this.fontSize = 16});
  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return PageTitle(title: title, fontSize: fontSize);
  }
}
