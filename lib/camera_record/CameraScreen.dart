import 'dart:async';
import 'dart:math';


import 'package:cameara_stream/camera_record/TextUi.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'CameraView.dart';
import 'VideoView.dart';
import '../countdownt/count_timer_page.dart';


 List<CameraDescription>? cameras;

class CameraScreen extends StatefulWidget {
  CameraScreen({ Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  Future<void>? cameraValue;
  bool isRecoring = false;
  bool isPauseRecoding=false;
  bool flash = false;
  bool iscamerafront = true;
  double transform = 0;

  static const maxSeconds=10;
  int seconds=maxSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high);
    cameraValue = _cameraController!.initialize();
  }
@override
  void dispose() {
    super.dispose();
    _cameraController!.dispose();
  }

  void startTimer({bool reset=true,context}) {
    if(reset){
      resetTimer();
    }
    print("start timer");
    timer=Timer.periodic(Duration(seconds:1), (timer) {
      if(seconds>0){
        setState(() {
          seconds--;
        });
      }else {
        stopTimer(reset: false);
        stopVideoRecoding(context);

      }

    });
  }


  void stopVideoRecoding(context)async{
    XFile videopath = await _cameraController!.stopVideoRecording();
    setState(() {
      isRecoring = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => VideoViewPage(
              path: videopath.path,
            )));
  }



  void stopTimer({bool reset=true}) {
    if(reset){
      resetTimer();
    }
    setState(() {
      timer?.cancel();

    });
  }
  void resetTimer() {
    setState(() {
      seconds=maxSeconds;

    });
  }
  void pauseRecoding()async{
    setState(() {
      isPauseRecoding=!isPauseRecoding;
      print(isPauseRecoding);
    });
    if(isPauseRecoding==true){
      await _cameraController!.pauseVideoRecording();

    }else{
      await _cameraController!.resumeVideoRecording();
    }
    setState(() {
    isRecoring = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                      child: Stack(
                        children: [
                          Container(

                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height*0.85,
                              padding:const EdgeInsets.only(top:25),
                              child: CameraPreview(_cameraController!)),

                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: buildTimer(isRecoring)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 150),
                            child: Align(
                                alignment: Alignment.center,
                                child: TextUI()),
                          ),

                        ],
                      ));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),

          Positioned(
            bottom: 0.0,
            child: Container(
              height: MediaQuery.of(context).size.height*0.15,
              color: Colors.black,
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                           flex:1,
                          child: buildIconFlag()),

                      isRecoring==false?Container():InkWell(
                          onTap: ()=>pauseRecoding(),
                          child: buildPauseIcons()),
                      Expanded(
                        flex:1,
                        child: GestureDetector(
                          // onTap: () async {
                          //   await _cameraController!.startVideoRecording();
                          //   setState(() {
                          //     isRecoring = true;
                          //   });
                          // },
                          // onLongPressUp: () async {
                          //   XFile videopath = await _cameraController!.stopVideoRecording();
                          //   setState(() {
                          //     isRecoring = false;
                          //   });
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (builder) => VideoViewPage(
                          //                 path: videopath.path,
                          //               )));
                          // },
                          onLongPress: () {
                            if (!isRecoring) takePhoto(context);
                          },
                          child: isRecoring
                              ? InkWell(
                            onTap: ()async{
                              XFile videopath = await _cameraController!.stopVideoRecording();
                              setState(() {
                                isRecoring = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => VideoViewPage(
                                        path: videopath.path,
                                      )));
                            },
                                child:  const Icon(
                                    Icons.radio_button_on,
                                    color: Colors.red,
                                    size: 80,
                                  ),
                              )
                              : InkWell(
                            onTap: ()async{
                              startTimer(context: context);
                              await _cameraController!.startVideoRecording();
                              setState(() {
                              isRecoring = true;

                              });

                            },
                                child: const Icon(
                                    Icons.panorama_fish_eye,
                                    color: Colors.white,
                                    size: 70,
                                  ),
                              ),
                        ),
                      ),
                      Expanded(
                          flex:1,
                          child: buildIconCamera()),

                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Tap starting record video",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
  Widget  buildIconFlag() {
    return  IconButton(
        icon: Icon(
          flash ? Icons.flash_on : Icons.flash_off,
          color: Colors.white,
          size: 28,
        ),
        onPressed: () {
          setState(() {
            flash = !flash;
          });
          flash
              ? _cameraController!
              .setFlashMode(FlashMode.torch)
              : _cameraController!.setFlashMode(FlashMode.off);
        });
  }
 Widget buildPauseIcons() {
   if (isPauseRecoding == true) {
     return Icon(Icons.play_arrow, color: Colors.white,);
   } else {
     return  Icon(Icons.pause, color: Colors.white,);
   }
 }
  Widget buildIconCamera() {
    return IconButton(
        icon: Transform.rotate(
          angle: transform,
          child: const Icon(
            Icons.flip_camera_ios,
            color: Colors.white,
            size: 28,
          ),
        ),
        onPressed: () async {
          setState(() {
            iscamerafront = !iscamerafront;
            transform = transform + pi;
          });
          int cameraPos = iscamerafront ? 0 : 1;
          _cameraController = CameraController(
              cameras![cameraPos], ResolutionPreset.high);
          cameraValue = _cameraController!.initialize();
        });
  }
  void takePhoto(BuildContext context) async {
    XFile file = await _cameraController!.takePicture();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => CameraViewPage(
                  path: file.path
                )));
  }

 Widget renderText(bool isRecoring) {
    // if(isRecoring){
    //   return Text("Question there");
    // }else{
    //
    // }
    // return isRecoring==true? Text("Question there",style: TextStyle(color: Colors.green,fontSize: 20),):Container();
    return  isRecoring?Container(
      margin: EdgeInsets.all(30),
      width: 200,
        height: 200,
        color: Colors.red,
        child: Text("Question there",style: TextStyle(color: Colors.green,fontSize: 20),)):Container();
 }
 Widget buildTimer(bool isRecodring){
    return isRecodring? Container(
      margin:const EdgeInsets.all(20),
      width: 50,
      height: 50,
      child: Stack(
        fit: StackFit.expand,
        children:  [
          CircularProgressIndicator(
            value:1-seconds/maxSeconds,
            strokeWidth: 5,
            valueColor:const AlwaysStoppedAnimation(Colors.white),
            backgroundColor: Colors.red,
          ),
          Center(
            child: Text("$seconds",style:const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
          )
        ],
      ),
    ):Container();
 }


}
