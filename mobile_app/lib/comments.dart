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
        primarySwatch: Colors.blue,
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
  String _list = "Comments: ";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Location",
        home: Scaffold(
            backgroundColor: Colors.lightGreen[100],
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Maps()),
                      );
                    },
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                      );
                    },
                    child: const Text('Home'),
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
                    onPressed: () {
                      //send comment to db
                      String list = _list +
                          "\n" +
                          dropdownValue +
                          ":  " +
                          cmntController.text;
                      setState(() {
                        _list = list;
                      });
                    },
                    child: const Text('Add comment'),
                  ),
                  Text(
                    _list,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )));
  }
}
