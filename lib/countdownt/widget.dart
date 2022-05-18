import 'package:flutter/material.dart';
class ButtonWidget extends StatelessWidget {
  const ButtonWidget({Key? key,required this.text,required this.onClicked}) : super(key: key);
final  String text;
final VoidCallback onClicked;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onClicked,
        child: Text(text,style: const TextStyle(fontSize: 22),));
  }
}
