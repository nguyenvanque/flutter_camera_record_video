import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewPage extends StatefulWidget {
   VideoViewPage({required this.path});
  final String path;

  @override
  _VideoViewPageState createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {


        });
      });

    _controller.addListener(() {
      setState(() {

      });
    });

    // lắng nghe sự kiện trong lúc phát video
    // _controller.addListener(() {
    //   if(!_controller.value.isPlaying){
    //     setState(() {
    //       _controller.pause();
    //     });
    //   }else{
    //     setState(() {
    //       _controller.play();
    //     });
    //   }
    //
    // });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   actions: [
      //     IconButton(
      //         icon: const Icon(
      //           Icons.crop_rotate,
      //           size: 27,
      //         ),
      //         onPressed: () {}),
      //     IconButton(
      //         icon: const Icon(
      //           Icons.emoji_emotions_outlined,
      //           size: 27,
      //         ),
      //         onPressed: () {}),
      //     IconButton(
      //         icon: const Icon(
      //           Icons.title,
      //           size: 27,
      //         ),
      //         onPressed: () {}),
      //     IconButton(
      //         icon: const Icon(
      //           Icons.edit,
      //           size: 27,
      //         ),
      //         onPressed: () {}),
      //   ],
      // ),
      body: Container(
        padding: EdgeInsets.only(top: 30),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height *0.9,
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(_controller),
                          Positioned(
                              top: -5,
                              width: MediaQuery.of(context).size.width,
                              child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: false,

                                colors: const VideoProgressColors(
                                    backgroundColor: Colors.blueGrey,
                                    bufferedColor: Colors.blueGrey,
                                    playedColor: Colors.red),
                              )),
                        ],
                          ),
                    )
                  : Container(),
            ),

            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  maxLines: 6,
                  minLines: 1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add Caption....",
                      prefixIcon: const Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                        size: 27,
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      suffixIcon: CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.tealAccent[700],
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 27,
                        ),
                      )),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.black38,
                  child:  Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
