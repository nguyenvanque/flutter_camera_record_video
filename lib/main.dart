import 'package:cameara_stream/camera_record/CameraScreen.dart';
import 'package:cameara_stream/camera_record/RecordVideoPage.dart';
import 'package:cameara_stream/text_speech_camera/home.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  camerasList = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter camera record video',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  RecordVideoPage(),
    );
  }
}



