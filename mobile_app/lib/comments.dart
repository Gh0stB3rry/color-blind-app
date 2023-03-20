import 'dart:math';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/maps.dart';
import 'package:image_picker/image_picker.dart';

const List<String> locationList = <String>[
  'Linderman Library',
  'Fairchild-Martindale Library',
  'Lehigh Bookstore',
  'Images'
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
  File? galleryFile;
  final picker = ImagePicker();

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          setState(() {
            _imgList.add(File(pickedFile!.path));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  TextEditingController cmntController = TextEditingController();
  String dropdownValue = locationList.first;
  String _lindermanList = "Comments: ";
  String _fmlList = "Comments: ";
  String _storeList = "Comments: ";
  List<File> _imgList = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Location",
        home: Scaffold(
            backgroundColor: Colors.lightGreen[100],
            body: Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SingleChildScrollView(
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
                      child: const Text('Select Image from Gallery and Camera'),
                      onPressed: () {
                        _showPicker(context: context);
                      },
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
                        } else if (dropdownValue == "Lehigh Bookstore") {
                          return _storeList;
                        } else {
                          return "";
                        }
                      }()),
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 200.0,
                      width: 300.0,
                      child: _imgList.length < 1
                          ? const Center(child: Text(''))
                          : dropdownValue == "Images"
                              ? Center(child: Image.file(_imgList[0]))
                              : const Center(child: Text('')),
                    ),
                    SizedBox(
                      height: 200.0,
                      width: 300.0,
                      child: _imgList.length < 2
                          ? const Center(child: Text(''))
                          : dropdownValue == "Images"
                              ? Center(child: Image.file(_imgList[1]))
                              : const Center(child: Text('')),
                    ),
                    SizedBox(
                      height: 200.0,
                      width: 300.0,
                      child: _imgList.length < 3
                          ? const Center(child: Text(''))
                          : dropdownValue == "Images"
                              ? Center(child: Image.file(_imgList[2]))
                              : const Center(child: Text('')),
                    ),
                  ],
                ),
              ),
            ))));
  }
}
