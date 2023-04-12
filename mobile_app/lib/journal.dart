import 'dart:math';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:image_picker/image_picker.dart';

class Journal extends StatelessWidget {
  const Journal({super.key});

  // This widget is the root of your application.
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
            galleryFile = File(pickedFile!.path);
            imgFlag = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  TextEditingController cmntController = TextEditingController();
  List<String> _journalList = [];
  List<File?> _ImgList = [];
  List<bool> _imgBoolList = [];
  bool imgFlag = false;

  DateTime now = DateTime.now();
  final location = Position(latitude: 40.6049, longitude: -75.3775);

  Widget _buildPopupDialog(BuildContext context, index) {
    return AlertDialog(
      title: const Text('Journal Entry'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_journalList[index],
              style:
                  GoogleFonts.lato(fontWeight: FontWeight.w500, fontSize: 12))
        ],
      ),
      actions: <Widget>[
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
            body: Center(
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
                      Text(
                        "~ My Journal ~",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.indigo.shade300),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Date: " +
                            now.month.toString() +
                            "/" +
                            now.day.toString() +
                            "/" +
                            now.year.toString(),
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Text(
                          "Location: " +
                              location.latitude.toString() +
                              " " +
                              location.longitude.toString(),
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w500, fontSize: 16))
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: cmntController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Journal Entry',
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade300),
                    child: const Text('Select Image'),
                    onPressed: () {
                      _showPicker(context: context);
                    },
                  ),
                  SizedBox(
                    height: galleryFile == null ? 0.0 : 200.0,
                    width: galleryFile == null ? 0.0 : 300.0,
                    child: galleryFile == null
                        ? const Center(child: Text(''))
                        : Center(child: Image.file(galleryFile!)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade300),
                    onPressed: () {
                      setState(() {
                        _journalList.add(cmntController.text);
                        if (imgFlag) {
                          _ImgList.add(galleryFile!);
                          _imgBoolList.add(true);
                          imgFlag = false;
                        } else {
                          _ImgList.add(null);
                          _imgBoolList.add(false);
                        }
                        galleryFile = null;
                        cmntController.clear();
                      });
                    },
                    child: const Text('Add Entry'),
                  ),
                  Divider(color: Colors.black),
                  Expanded(
                      child: SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _journalList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: _imgBoolList[index] ? 150 : 50,
                                  width: 250,
                                  alignment: Alignment.center,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                now.month.toString() +
                                                    "/" +
                                                    now.day.toString() +
                                                    "/" +
                                                    now.year.toString(),
                                                style: GoogleFonts.lato(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12)),
                                            Text(
                                                "at " +
                                                    location.latitude
                                                        .toString() +
                                                    " " +
                                                    location.longitude
                                                        .toString(),
                                                style: GoogleFonts.lato(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.indigo.shade300),
                                          child: Text('Show Message',
                                              style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12)),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildPopupDialog(
                                                      context, index),
                                            );
                                          },
                                        ),
                                      ])),
                              _imgBoolList[index]
                                  ? Container(
                                      height: 150,
                                      width: 130,
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Image?.file(_ImgList[index]!),
                                    )
                                  : SizedBox(width: 130)
                            ]);
                      },
                    ),
                  ))
                ],
              ),
            ))));
  }
}
