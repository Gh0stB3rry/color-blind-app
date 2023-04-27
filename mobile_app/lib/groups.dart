import 'dart:math';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:image_picker/image_picker.dart';

class Groups extends StatelessWidget {
  const Groups({super.key});

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController cmntController = TextEditingController();
  TextEditingController descController = TextEditingController();
  var _groupList = [
    [
      "test",
      "Public",
      "ishan@gmail.com",
      "my first group, seeing how it works"
    ],
    [
      "Bookstores!!",
      "Public",
      "ishan@gmail.com",
      "A group for all who love bookstores!!"
    ],
    ["Libraries are cool", "Public", "kayla@gmail.com", "I like books. Do you?"]
  ];
  var _groupEntry = [false, false, false];
  var _pubpriv = false;

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Group Creation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: cmntController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Group Name',
            ),
          ),
          SizedBox(height: 5),
          TextField(
            maxLines: null,
            controller: descController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            if (cmntController.text.isNotEmpty &&
                descController.text.isNotEmpty) {
              setState(() {
                _groupList.add([
                  cmntController.text,
                  "Public",
                  "ishan@gmail.com",
                  descController.text
                ]);
                _groupEntry.add(true);
              });
              cmntController.clear();
              descController.clear();
              Navigator.of(context).pop();
            }
          },
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
          child: const Text('Create'),
        ),
        ElevatedButton(
          onPressed: () {
            cmntController.clear();
            descController.clear();
            Navigator.of(context).pop();
          },
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildGroupDialog(BuildContext context, index) {
    return AlertDialog(
      title: const Text('Group Description'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_groupList[index][3],
              style:
                  GoogleFonts.lato(fontWeight: FontWeight.w500, fontSize: 12))
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(() {
              _groupEntry[index] = true;
            });
            Navigator.of(context).pop();
          },
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
          child: const Text('Join'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Location",
        home: Scaffold(
            backgroundColor: Colors.lightGreen[100],
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/assets/mountain.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
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
                          SizedBox(width: 60),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo.shade300),
                            child: const Text('Create a Group'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Existing Groups",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.indigo.shade300),
                      ),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                height: 30,
                                width: 380,
                                alignment: Alignment.center,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                          width: 95,
                                          child: Text(
                                            "Name",
                                            style: GoogleFonts.lato(
                                                color: Colors.indigo.shade500),
                                          )),
                                      Container(
                                          width: 75,
                                          child: Text(
                                            "Visibility",
                                            style: GoogleFonts.lato(
                                                color: Colors.indigo.shade500),
                                          )),
                                      Container(
                                          width: 110,
                                          child: Text(
                                            "Creator",
                                            style: GoogleFonts.lato(
                                                color: Colors.indigo.shade500),
                                          )),
                                      Container(width: 95, child: Text("")),
                                    ])),
                          ]),
                      Divider(color: Colors.black),
                      Expanded(
                          child: SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _groupList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      height: 70,
                                      width: 380,
                                      alignment: Alignment.center,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                                width: 95,
                                                child: Text(
                                                  _groupList[index][0],
                                                  style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors
                                                          .indigo.shade500),
                                                )),
                                            Container(
                                                width: 50,
                                                child: Text(
                                                  _groupList[index][1],
                                                  style: GoogleFonts.lato(
                                                      color: Colors
                                                          .indigo.shade500),
                                                )),
                                            Container(
                                                width: 110,
                                                child: Text(
                                                  _groupList[index][2],
                                                  style: GoogleFonts.lato(
                                                      color: Colors
                                                          .indigo.shade500),
                                                )),
                                            Container(
                                              width: 95,
                                              child: _groupEntry[index] == false
                                                  ? _groupList[index][1] ==
                                                          "Public"
                                                      ? ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .indigo
                                                                          .shade300),
                                                          child: Text(
                                                              'Join Group',
                                                              style: GoogleFonts.lato(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      12)),
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  _buildGroupDialog(
                                                                      context,
                                                                      index),
                                                            );
                                                          },
                                                        )
                                                      : ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .indigo
                                                                          .shade300),
                                                          child:
                                                              Icon(Icons.check),
                                                          onPressed: () => {},
                                                        )
                                                  : ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.indigo
                                                                      .shade300),
                                                      child: Icon(Icons.check),
                                                      onPressed: () => {},
                                                    ),
                                            )
                                          ])),
                                ]);
                          },
                        ),
                      ))
                    ],
                  ),
                )))));
  }
}
