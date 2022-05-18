import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayListPage extends StatefulWidget {
   VideoPlayListPage({required this.path});
  final List<String> path;

  @override
  _VideoPlayListPageState createState() => _VideoPlayListPageState();
}

class _VideoPlayListPageState extends State<VideoPlayListPage> {
  late VideoPlayerController _controller;
  int indexVideo=0;

  @override
  void initState() {
    super.initState();

    for(String i in widget.path){
       print ("Path video $i\n");
    }

    initVideoController(0);


  }

  void initVideoController(index){
     _controller = VideoPlayerController.file(File(widget.path[index]))
   ..initialize().then((_) {
      setState(() {

      });
    });

    _controller.addListener(() {
      setState(() {
        print(_controller.value);

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.only(top: 30),
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
                      suffixIcon: InkWell(
                        onTap: (){
                          setState(() {
                            indexVideo++;
                            initVideoController(indexVideo);
                          });
                        },
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: Colors.tealAccent[700],
                          child: const Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                            size: 27,
                          ),
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
