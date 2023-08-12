import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Past_recoding_Page extends StatefulWidget {
  Past_recoding_Page({super.key});

  // final String filePath;

  @override
  State<Past_recoding_Page> createState() => _Past_recoding_PageState();
}

class _Past_recoding_PageState extends State<Past_recoding_Page> {
  final audioPlayer = AudioPlayer();
  bool is_playing = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(":");
  }

  @override
  void initState() {
    super.initState();

    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        is_playing = event == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Past Recordings"),
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: ElevatedButton(
              onPressed: () async {
                if (is_playing) {
                  await audioPlayer.pause();
                } else {
                  // String url =
                  //    ;
                  // await audioPlayer.play();
                }
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Recording : ${index + 1}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Icon(
                        is_playing ? Icons.pause : Icons.play_arrow_outlined,
                        size: 40,
                      )
                    ],
                  ),
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    activeColor: Colors.white,
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatTime(position)),
                            Text(formatTime(duration)),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
