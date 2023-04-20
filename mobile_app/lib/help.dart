import 'package:flutter/material.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);
  static const String _title = 'Help';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
      // and so on for every text style
  
        ),
      ),
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Center(  
          child: const Text('This is our app where we want to make mental health accessible to everyone!\n\n\nHow to use: \n\nIf you want to record a message or image for others to share, click the drop down button to find your college.\nAfter, find the location you want to blog and click the icon.\n\nIf you want to leave a priviate message in the journal, click the journal button on the upper-left corner. This will allow you to leave a priviate message or image. This does record the date and your location as well!\n\n\n\n\n\nENJOY!', 
          style: TextStyle(fontSize: 35),),

           
      ),  
        backgroundColor: Colors.lightGreen[100],
      ),
    );
  }
}

