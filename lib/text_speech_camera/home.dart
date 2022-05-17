import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'speech_to_text_screen.dart';

class HomeCameraText extends StatefulWidget {
  const HomeCameraText({Key? key}) : super(key: key);

  @override
  State<HomeCameraText> createState() => _HomeCameraTextState();
}

class _HomeCameraTextState extends State<HomeCameraText> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder(
          future: availableCameras(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final CameraDescription frontCamera =
              (snapshot.data as List<CameraDescription>).firstWhere(
                      (CameraDescription element) =>
                  element.lensDirection == CameraLensDirection.front);
              return Center(
                  child: FlatButton(
                    child: Text("Open speech to text"),
                    onPressed: () async {
                      SpeechToTextCameraResult result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SpeechToTextScreen(frontCamera)));
                      if(result!=null){
                        print(result.toString());
                      }
                    },
                  ));
            } else {
              return Container();
            }
          }),
    );
  }
}
