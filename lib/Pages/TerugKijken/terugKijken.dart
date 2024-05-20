import 'package:flutter/material.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/chartsLeftPart.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/video.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/chartsLowerPart.dart';



class TerugKijken extends StatelessWidget {
  TerugKijken({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold( body: SingleChildScrollView(
      padding: pagePadding,
      child: Column(
        children: [
          Row(
            children: [
              ChartsLeftPart(),
              Video()
            ]
          ),
          ChartsLowerPart(),
        ]
      )
    ));
  }

}