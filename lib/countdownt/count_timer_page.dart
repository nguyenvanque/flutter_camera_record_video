import 'dart:async';


import 'package:cameara_stream/countdownt/widget.dart';
import 'package:flutter/material.dart';
class CountTimerPage extends StatefulWidget {
  const CountTimerPage({Key? key}) : super(key: key);

  @override
  State<CountTimerPage> createState() => _CountTimerPageState();
}

class _CountTimerPageState extends State<CountTimerPage> {
  static const maxSeconds=60;
  int seconds=maxSeconds;
  Timer? timer;

  void startTimer({bool reset=true}) {
    if(reset){
      resetTimer();
    }
    timer=Timer.periodic(Duration(milliseconds:50), (timer) {
      if(seconds>0){
        setState(() {
          seconds--;
        });
      }else{
        stopTimer(reset: false);
      }

    });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Column(
          children: [
            buildTimer(),
            // buildTime(),
            buildButton()
          ],
        ),
      ),
    );
  }

Widget  buildTime() {
    if(seconds==0){
      return Icon(Icons.done,color: Colors.green,size: 130,);
    }else{
      return Text('$seconds',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),) ;

    }
}
  Widget buildButton(){
    final isRunning=timer==null? false:timer!.isActive;
    final isCompleted=seconds==maxSeconds|| seconds==0;
    return isRunning|| !isCompleted? Row(
      children: [
        ButtonWidget(text:isRunning? "Pause":"Resume", onClicked: (){
         if(isRunning){
           stopTimer(reset: false);

         }else{
           startTimer(reset: false);
         }
        }),
        const SizedBox(width: 30,),
        ButtonWidget(text: "Cancel", onClicked: (){
          print("hello");
          stopTimer(reset: true);
        }),
      ],
    ):ButtonWidget(text: "Start", onClicked: (){
      startTimer();
    });
  }

Widget  buildTimer() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value:1-seconds/maxSeconds ,
            strokeWidth: 12,
            valueColor: AlwaysStoppedAnimation(Colors.black),
            backgroundColor: Colors.green,
          ),
          Center(
            child: buildTime(),
          )
        ],
      ),
    );
}



}


