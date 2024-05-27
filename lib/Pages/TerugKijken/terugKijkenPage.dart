import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/chartsLeftPart.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/videoPlayer.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/chartsLowerPart.dart';
import 'package:zuurstofmasker/Pages/TerugKijken/TerugKijkenNavBar.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:video_player/video_player.dart';

class TerugKijken extends StatelessWidget {
  TerugKijken({super.key, required this.session}) {
    loadVideoPlayer();
  }
  final Session session;

  VideoPlayerController? controller;

  void loadVideoPlayer() {
    controller?.dispose();
    var path = "$sessionPath${session.id}\\video.mp4";
    if (File(path).existsSync()) {
      controller = VideoPlayerController.file(File(path));
    }
  }

  void chartTouche(LineTouchResponse? lineTouchResponse, double? value) {
    if (controller == null || value == null) {
      return;
    }
    int timeMs = value!.toInt() * 1000;
    if (controller!.value.duration.inMilliseconds > timeMs) {
      controller?.seekTo(Duration(milliseconds: timeMs));
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: pagePadding,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TerugKijkenNavBar(session: session),
              const PaddingSpacing(
                multiplier: 1,
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  height: 600,
                  width: 442,
                  child:
                      ChartsLeftPart(session: session, callback: chartTouche),
                ),
                const PaddingSpacing(
                  multiplier: 2,
                ),
                VideoPlr(
                  session: session,
                  controller: controller,
                )
              ]),
              const PaddingSpacing(
                multiplier: 2,
              ),
              SizedBox(
                height: 300,
                width: 1900,
                child: ChartsLowerPart(
                  session: session,
                  callback: chartTouche,
                ),
              ),
            ])));
  }
}
