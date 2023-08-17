import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart' as fireStore;
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  final firebase = FirebaseAuth.instance;
  UploadTask? uploadTask;

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

  void removeSpecialCharacters() {
    final output = audioPath.replaceAll(audioPath, '');
    setState(() {
      audioPath = output;
    });
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

  Future uploadFile() async {
    final List<String> folders = audioPath.split("/");
    print(folders[folders.length - 1]);
    final path =
        "${firebase.currentUser!.uid.toString()}/ ${folders[folders.length - 1]}";
    final file = File(audioPath);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    setState(() {
      uploadTask = null;
    });
    final urlDownload = await snapshot.ref.getDownloadURL();
    print(urlDownload);

    setState(() async {
      await fireStore.FirebaseFirestore.instance
          .collection("${await firebase.currentUser!.uid}")
          .doc()
          .set({"url": "${await urlDownload}"});
    });
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
                        uploadFile();
                      },
                      child: Text("Save the audio")),
                  ElevatedButton(
                      onPressed: removeSpecialCharacters,
                      child: Text("Delete the audio")),
                ],
              ),
            ),
          buildProgress()
        ],
      )),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.greenAccent,
                  ),
                  Center(
                    child: Text(
                      "${100 * progress.roundToDouble()}%",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 30,
            );
          }
        },
      );
}
