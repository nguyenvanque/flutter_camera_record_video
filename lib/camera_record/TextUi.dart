import 'package:flutter/material.dart';


class TextUI extends StatefulWidget {
  const TextUI({Key? key}) : super(key: key);

  @override
  State<TextUI> createState() => _TextUIState();
}

class _TextUIState extends State<TextUI> {
  @override
  Widget build(BuildContext context) {
    return buildBody();
  }
  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(

          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Center(
                child:  Column(
                  children: [
                    Container(
                      width: 50,
                      height:40,
                      
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,

                      ),

                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Q1",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Text("  'Welcome! You use app osyter!'",textAlign: TextAlign.center,
                        style:TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold))
                  ],
                )),

          ]),
        ),

      ],
    );
  }




}



