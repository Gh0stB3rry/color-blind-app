import 'package:flutter/material.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'dart:math';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';
import 'package:color_blindness/color_blindness.dart';


class imageChanger extends StatelessWidget{
  const imageChanger({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Mobile App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: MyHomePage(title: 'Home Page'),
      );
  }
}



//////////////////////////////////
/// class for changing the image
class changeImage extends StatelessWidget {
  const changeImage({Key? key, required this.imagePath}) : super(key:key);
  final String imagePath;


  @override
  Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(title: Text('Red-green changes')),
    body: Center(
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix([
          1, 0, 0, 0, 0,
          0, 0.7, 0.4, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child:Image.asset(imagePath),
    ),
    ),
  );
}
}
///////////////////////////////////
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}





class _MyHomePageState extends State<MyHomePage> {

  int index = 0;

  bool clicked = false;



////////////////////////////
///function for the test
  @override
  Widget build(BuildContext context) {
    //image holder
    String displayImage = "lib/colorImages/redGreen42.png";
    return MaterialApp(
      title: "Image changer",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 69, 236, 119),
        appBar: AppBar(
          title: const Text('Image changer'),
          backgroundColor: Color.fromARGB(255, 73, 236, 195),
          actions: [
          
          SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen.shade300,
                minimumSize: Size(64, 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  side: BorderSide(
                    color: Colors.lightGreen.shade300)),
              ),
              child: Icon(
                Icons.home,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Home()),
                );
              },
            ),
                          
          /*
          actions: [
            Padding(padding: const EdgeInsets.all(18.0), 
                    child: Text('Score: $score',
                    style: const TextStyle(fontSize: 18.0),
                    )
            ),
          ],
          */
          ],
        ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
              child: clicked
                ? ColorFiltered(
                    colorFilter: ColorFilter.matrix([
                      0.95, 0.05, 0, 0, 0, // Red channel
                      0.0, 0.43, 0.57, 0, 0, // Green channel blended with red
                      0, 0.24, 0.76, 0, 0, // Blue channel
                      0, 0, 0, 1, 0, // Alpha channel
                    ]),
                    child: Image.asset(displayImage),
                  )
                : Image.asset(displayImage),
          ),
              //}
              //////////////
              ///////////////
              SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen.shade300,
                  minimumSize: Size(80, 80),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(
                          color: Colors.white)),
                ),
                child: const Text('Convert'),
                onPressed: () {
                  setState((){
                    clicked = !clicked;
                  });
                },
                // Text(clicked ? "put image back" : "change image")
              ),
            /////////////
              /////////////////
            ],
          ),
        ),
        
    );
  }
}