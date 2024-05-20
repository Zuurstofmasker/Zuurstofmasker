import 'package:flutter/material.dart';
import 'package:zuurstofmasker/config.dart';

class Video extends StatelessWidget {
  Video({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        height: 600,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: borderRadius),
      ),
    );
  }
}
