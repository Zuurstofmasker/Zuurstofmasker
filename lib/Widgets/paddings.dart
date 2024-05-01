import 'package:flutter/material.dart';
import 'package:zuurstofmasker/config.dart';

class PaddingSpacing extends StatelessWidget {
  const PaddingSpacing({super.key, this.multiplier = 1});
  final int multiplier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mainPaddingSize * multiplier,
      height: mainPaddingSize * multiplier,
    );
  }
}
