import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
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
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return FutureBuilder<List<Widget>>(
                                future: calcThumbs(value),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return ProgressBar(
                                      progress: controller!.value.position,
                                      total: controller!.value.duration,
                                      progressBarColor: Colors.blue,
                                      baseBarColor: Colors.white,
                                      bufferedBarColor: Colors.white,
                                      thumbColor: Colors.blue[800],
                                      timeLabelTextStyle:
                                          const TextStyle(color: Colors.white),
                                      barHeight: 3.0,
                                      thumbRadius: 5.0,
                                      onSeek: (duration) {
                                        controller?.seekTo(duration);
                                        // print(duration);
                                      },
                                    );
                                  } else {
                                    return Stack(
                                      children: [
                                        ProgressBar(
                                          progress: controller!.value.position,
                                          total: controller!.value.duration,
                                          progressBarColor: Colors.blue,
                                          baseBarColor: Colors.white,
                                          bufferedBarColor: Colors.white,
                                          thumbColor: Colors.blue[800],
                                          timeLabelTextStyle: const TextStyle(
                                              color: Colors.white),
                                          barHeight: 3.0,
                                          thumbRadius: 5.0,
                                          onSeek: (duration) {
                                            controller?.seekTo(duration);
                                            // print(duration);
                                          },
                                        ),
                                        ...snapshot.data!,
                                      ],
                                    );
                                  }
                                },
                              );
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

  Future<List<Widget>> calcThumbs(VideoPlayerValue value) async {
    List<Widget> thumbList = [];
    Map<Duration, String> thumbPositions = {};

    List<dynamic> rawThumbList = await getListFromFile(
        "$sessionPath${widget.session.id}/videoNotes.json");

    rawThumbList.forEach((i) {
      Map<String, dynamic> item = i;
      String note = "";
      Duration time = Duration.zero;
      item.forEach((k, v) {
        if (k == "time") {
          List<String> parts = v.split(":");
          int hours = parts.length == 3 ? int.parse(parts[0]) : 0;
          int minutes = int.parse(parts[parts.length - 2]);
          int seconds = int.parse(parts[parts.length - 1]);

          time = Duration(hours: hours, minutes: minutes, seconds: seconds);
        }
        if (k == "note") {
          note = v;
        }
      });

      thumbPositions[time] = note;
    });
    

    double progressBarWidth = 0.9 * MediaQuery.of(context).size.width;
    thumbPositions.forEach((k, v) {
      double left =
          (k.inMilliseconds / value.duration.inMilliseconds) * progressBarWidth;

      thumbList.add(Positioned(
        left: left - 10, // Adjust for thumb width
        top: -15,
        bottom: 0,
        child: GestureDetector(
          onTap: () {
            // Handle thumb tap
            print("Thumb at $k tapped!");
            PopupAndLoading.showSuccess(v);
          },
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: const BoxDecoration(
              color: dangerColor,
              shape: BoxShape.rectangle,
            ),
          ),
        ),
      ));
    });

    return thumbList;
  }
}
