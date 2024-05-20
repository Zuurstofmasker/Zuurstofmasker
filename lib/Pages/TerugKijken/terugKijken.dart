import 'package:flutter/material.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/chartsLeftPart.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/video.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/chartsLowerPart.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/TerugKijkenNavBar.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Models/session.dart';



class TerugKijken extends StatelessWidget {
  TerugKijken({super.key,  required this.session});


 final Session session;

  @override
  Widget build(BuildContext context){
    return Scaffold( body: SingleChildScrollView(
      padding: pagePadding,
      child: Column(
              mainAxisSize: MainAxisSize.min,
        children: [
          TerugKijkenNavBar(session: session),
             PaddingSpacing(
                multiplier: 1,
              ),
          Row(
            children: [
                Container(
                  height: 600,
                  width: 442,
                  child: ChartsLeftPart(),
                ),
                   const PaddingSpacing(
                  multiplier: 2,
                ),
              Video()
            ]
          ),
          const PaddingSpacing(
                  multiplier: 2,
                ),
          Container(
                  height: 300,
                  width: 1900,
                  child:   ChartsLowerPart(),
          ),
        ]
      )
    ));
  }

}