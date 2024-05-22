import 'package:flutter/material.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class Video extends StatelessWidget {
  Video({super.key, required this.session});

  final Session session;

  VideoPlayerController controller = VideoPlayerController.file(File("C\\sUsers\\timgr\\Downloads\\videoplayback.mp4"));


  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        height: 600,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: borderRadius),
            child: Stack(children: [
          VideoPlayer(controller!),
          Positioned(
              bottom: 0,
              child: Column(children: [
                ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: controller!,
                  builder: ((context, value, child) {
                    int minute = value.position.inMinutes;
                    int second = value.position.inSeconds % 60;
                    String timeStr = "$minute:$second";
                    if (value.isCompleted) timeStr = "$timeStr (completed)";
                    return Text(timeStr,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.white,
                            backgroundColor: Colors.black54));
                  }),
                ),
               
                ElevatedButton(
                    onPressed: () => controller?.play(),
                    child: const Text("Play")),
                ElevatedButton(
                    onPressed: () => controller?.pause(),
                    child: const Text("Pause")),
                ElevatedButton(
                    onPressed: () => controller?.seekTo(Duration(
                        milliseconds:
                            controller!.value.position.inMilliseconds +
                                10 * 1000)),
                    child: const Text("Forward")),
                ElevatedButton(
                    onPressed: () {
                      int ms = controller!.value.duration.inMilliseconds;
                      var tt = Duration(milliseconds: ms - 1000);
                      controller?.seekTo(tt);
                    },
                    child: const Text("End")),
              ])),
        ]),
      ),
    );
  }
}
