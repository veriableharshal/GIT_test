import 'dart:io';

import 'package:cr_file_saver/file_saver.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  bool _is_recording = false;

  late Record audiorecord;
  late AudioPlayer audioPlayer;
  String audioPath = "";
  bool file_Saved = false;
  final Dio dio = Dio();
  double progress = 0.0;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audiorecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audiorecord.dispose();
    super.dispose();
  }

  Future<bool> save(String url, String filename) async {
    Directory directory;

// Here we are just checking if the user device is android or IOS
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          print("Running");
          directory = (await getTemporaryDirectory());
          print("Save Fuction");
          print(directory.path + "\nDirectory Path");
          String newPath = "";
          directory.path.split("/");

          List<String> folders = directory.path.split("/");
          for (var x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "0") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          print(newPath + "non");
          newPath = newPath + "/test_recording";

          directory = Directory(newPath);
          print(directory.path);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }

      File save_File = File(directory.path)..createSync(recursive: true);
      print(save_File);
      await CRFileSaver.saveFile(save_File.toString(),
          destinationFileName: "Test_Record.m4a");

      // To save with the file name.
    } catch (e) {
      print("Save Fuction Exection :: $e");
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        print('true');
        return true;
      } else {
        print('false');
        return false;
      }
    }
  }

  saveFile() async {
    setState(() {
      file_Saved = true;
    });

    bool saved = await save(audioPath, "Recording_test.m4a");

    setState(() {
      file_Saved = false;
    });
  }

  Future<void> startRecording() async {
    try {
      if (await audiorecord.hasPermission()) {
        await audiorecord.start();
        setState(() {
          _is_recording = !_is_recording;
        });
      } else {
        await Permission.microphone.request();
      }
    } catch (e) {
      print("Error of recording : $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audiorecord.stop();
      print(path);
      setState(() {
        _is_recording = false;
        audioPath = path!;
        print(audioPath + "Audio Path");
      });
    } catch (e) {
      print("Error of recording : $e");
    }
  }

  Future<void> playRecording(String path) async {
    try {
      print("****************************");
      Source urlSource = UrlSource(path);
      print(" Playing" + urlSource.toString());
      await audioPlayer.play(urlSource);
    } catch (e) {
      print("Play error : $e");
    }
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Center(
          child: file_Saved
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: progress,
                  ),
                )
              : Row(
                  children: [
                    const Text("Home page"),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          logOut();
                        });
                        print("log out");
                      },
                      child: const Icon(Icons.login),
                    ),
                  ],
                ),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_is_recording)
            Text(
              "Recording in progress",
              style: TextStyle(fontSize: 20),
            ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              child: Icon(
                _is_recording ? Icons.stop : Icons.mic,
                size: 80,
              ),
              onPressed: _is_recording ? stopRecording : startRecording,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          if (!_is_recording && audioPath.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                child: Text("Play Recording"),
                onPressed: () {
                  print(audioPath);
                  playRecording(audioPath);
                },
              ),
            ),
          if (!_is_recording && audioPath.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await saveFile();
                      },
                      child: Text("Save the audio")),
                  ElevatedButton(
                      onPressed: () {}, child: Text("Delete the audio")),
                ],
              ),
            )
        ],
      )),
    );
  }
}
