import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'speech_to_text_view.dart';

class SpeechToTextScreen extends StatefulWidget {
  final CameraDescription cameraDescription;

  const SpeechToTextScreen(this.cameraDescription);

  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  CameraController? _controller;
  String? _lastPath;
  bool donePressed = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameraDescription, ResolutionPreset.medium);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
          future: _controller!.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(children: [
                ClipRRect(
                  child: Transform.scale(
                    scale: _controller!.value.aspectRatio / size.aspectRatio,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: CameraPreview(_controller!),
                      ),
                    ),
                  ),
                ),
                SpeechToTextView(onRecordPressed: () async {
                  await deleteLastRecording();
                  await recordVideo(context);
                }, onClearPressed: () async {
                  await deleteLastRecording();
                }, onStopPressed: () async {
                  await stopVideoRecording();
                }, onDonePressed: (result) {
                  donePressed = true;
                  if (_lastPath != null) {
                    Navigator.pop(
                        context, SpeechToTextCameraResult(result, _lastPath!));
                  }
                })
              ]);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<void> recordVideo(BuildContext context) async {
    try {
      // Construct the path where the image should be saved using the
      // pattern package.
      final path = join(
        // Store the picture in the temp directory.
        // Find the temp directory using the `path_provider` plugin.
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.mov',
      );

      // Attempt to take a picture and log where it's been saved.
      // await _controller!.startVideoRecording(path);
      await _controller!.startVideoRecording();

      _lastPath = path;
    } catch (e) {
      // If an error occurs, log the error to the console.
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> stopVideoRecording() async {
    try {
      await _controller!.stopVideoRecording();
    } catch (e) {
      // If an error occurs, log the error to the console.
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> deleteLastRecording() async {
    if (_lastPath != null) {
      final File file = File(_lastPath!);
      await file.delete();
      _lastPath = null;
    }
  }
}

class SpeechToTextCameraResult {
  final String lastWords;
  final String videoPath;

  const SpeechToTextCameraResult(this.lastWords, this.videoPath);

  @override
  String toString() {
    return 'SpeechToTextCameraResult{lastWords: $lastWords, videoPath: $videoPath}';
  }
}
