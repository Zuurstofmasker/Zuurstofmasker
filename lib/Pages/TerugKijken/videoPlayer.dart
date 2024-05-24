import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoPlr extends StatefulWidget {
  const VideoPlr({super.key, required this.session});

  final Session session;

  @override
  State<VideoPlr> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlr> {
  VideoPlayerController? controller;

  bool videoExists = false;
  void reload() {
    var path = "$sessionPath${widget.session.id}\\video.mp4";
    videoExists = File(path).existsSync();
    if (videoExists) {
      controller?.dispose();

      controller = VideoPlayerController.file(File(path));

      controller!.initialize().then((value) {
        if (controller!.value.isInitialized) {
          controller!.play();
          setState(() {});
          controller!.addListener(() {
            if (controller!.value.isCompleted) {
              log("ui: player completed, pos=${controller!.value.position}");
            }
          });
        } else {
          log("video file load failed");
        }
      }).catchError((e) {
        log("controller.initialize() error occurs: $e");
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: 600,
        width: double.infinity,
        child: videoExists
            ? Stack(children: [
                VideoPlayer(controller!),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.9,
                      alignment: FractionalOffset.center,
                      child: ValueListenableBuilder<VideoPlayerValue>(
                        valueListenable: controller!,
                        builder: ((context, value, child) {
                          return ProgressBar(
                            progress: controller!.value.position,
                            total: controller!.value.duration,
                            progressBarColor: Colors.blue,
                            baseBarColor: Colors.white,
                            bufferedBarColor: Colors.white,
                            thumbColor: Colors.blue[800],
                            timeLabelTextStyle: TextStyle(color: Colors.white),
                            barHeight: 3.0,
                            thumbRadius: 5.0,
                            onSeek: (duration) {
                              controller?.seekTo(duration);
                              // print(duration);
                            },
                          );
                        }),
                      ),
                    ),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () => controller?.seekTo(Duration(
                                  milliseconds: controller!
                                          .value.position.inMilliseconds -
                                      10 * 1000)),
                              child: const Icon(Icons.arrow_back)),
                          ValueListenableBuilder<VideoPlayerValue>(
                            valueListenable: controller!,
                            builder: ((context, value, child) {
                              return ElevatedButton(
                                  onPressed: () => value.isPlaying
                                      ? controller?.pause()
                                      : controller?.play(),
                                  child: value.isPlaying
                                      ? Icon(Icons.pause)
                                      : Icon(Icons.play_arrow));
                            }),
                          ),
                          ElevatedButton(
                              onPressed: () => controller?.seekTo(Duration(
                                  milliseconds: controller!
                                          .value.position.inMilliseconds +
                                      10 * 1000)),
                              child: const Icon(Icons.arrow_forward)),
                        ]),
                  ],
                ),
              ])
            : const Text("Geen video opgenomen"),
      ),
    );
  }
}
