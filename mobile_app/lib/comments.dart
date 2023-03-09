import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/maps.dart';

const List<String> locationList = <String>[
  'Linderman Library',
  'Fairchild-Martindale Library',
  'Lehigh Bookstore'
];

class Comments extends StatelessWidget {
  const Comments({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController cmntController = TextEditingController();
  String dropdownValue = locationList.first;
  String _lindermanList = "Comments: ";
  String _fmlList = "Comments: ";
  String _storeList = "Comments: ";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Location",
        home: Scaffold(
            backgroundColor: Colors.lightGreen[100],
            body: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
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
                            Icons.map,
                            size: 30.0,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Maps()),
                            );
                          },
                        ),
                      ],
                    ),
                    DropdownButton(
                      value: dropdownValue,
                      items: locationList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                    TextField(
                      controller: cmntController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Comment',
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade300),
                      onPressed: () {
                        //send comment to db
                        if (dropdownValue == "Linderman Library") {
                          String lindermanList = _lindermanList +
                              "\n" +
                              dropdownValue +
                              ":  " +
                              cmntController.text;
                          setState(() {
                            _lindermanList = lindermanList;
                          });
                        } else if (dropdownValue ==
                            "Fairchild-Martindale Library") {
                          String fmlList = _fmlList +
                              "\n" +
                              dropdownValue +
                              ":  " +
                              cmntController.text;
                          setState(() {
                            _fmlList = fmlList;
                          });
                        } else {
                          String storeList = _storeList +
                              "\n" +
                              dropdownValue +
                              ":  " +
                              cmntController.text;
                          setState(() {
                            _storeList = storeList;
                          });
                        }
                      },
                      child: const Text('Add comment'),
                    ),
                    Text(
                      (() {
                        if (dropdownValue == "Linderman Library") {
                          return _lindermanList;
                        } else if (dropdownValue ==
                            "Fairchild-Martindale Library") {
                          return _fmlList;
                        } else {
                          return _storeList;
                        }
                      }()),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            )));
  }
}
