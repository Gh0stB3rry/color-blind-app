import 'dart:math';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/maps.dart';
import 'package:image_picker/image_picker.dart';

class Comments extends StatelessWidget {
  const Comments({super.key, required this.name});
  final String name;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Home Page', name: name),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.name});

  final String title;
  final String name;

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
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  TextEditingController cmntController = TextEditingController();
  List<String> _lindermanList = [];
  List<String> _fmlList = [];
  List<String> _storeList = [];
  List<File> _lindermanImgList = [];
  List<File> _fmlImgList = [];
  List<File> _storeImgList = [];

  @override
  Widget build(BuildContext context) {
    String dropdownValue = widget.name;
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
                  SizedBox(height: 10),
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
                      //send comment to db
                      if (dropdownValue == "Linderman Library") {
                        setState(() {
                          _lindermanList.add(cmntController.text);
                          _lindermanImgList.add(galleryFile!);
                          galleryFile = null;
                          cmntController.clear();
                        });
                      } else if (dropdownValue ==
                          "Fairchild-Martindale Library") {
                        setState(() {
                          _fmlList.add(cmntController.text);
                          _fmlImgList.add(galleryFile!);
                          galleryFile = null;
                          cmntController.clear();
                        });
                      } else {
                        setState(() {
                          _storeList.add(cmntController.text);
                          _storeImgList.add(galleryFile!);
                          galleryFile = null;
                          cmntController.clear();
                        });
                      }
                    },
                    child: const Text('Add comment'),
                  ),
                  Text(dropdownValue + " Comments:"),
                  dropdownValue == "Linderman Library"
                      ? Expanded(
                          child: SizedBox(
                          height: 200.0,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _lindermanImgList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_lindermanList[index]),
                                  Container(
                                    height: 150,
                                    width: 225,
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child:
                                        Image?.file(_lindermanImgList[index]),
                                  )
                                ],
                              );
                            },
                          ),
                        ))
                      : dropdownValue == "Fairchild-Martindale Library"
                          ? Expanded(
                              child: SizedBox(
                              height: 200.0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _fmlImgList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(_fmlList[index]),
                                        Container(
                                          height: 150,
                                          width: 225,
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child:
                                              Image?.file(_fmlImgList[index]),
                                        )
                                      ]);
                                },
                              ),
                            ))
                          : dropdownValue == "Lehigh Bookstore"
                              ? Expanded(
                                  child: SizedBox(
                                  height: 200.0,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _storeImgList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(_storeList[index]),
                                            Container(
                                              height: 150,
                                              width: 225,
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Image?.file(
                                                  _storeImgList[index]),
                                            )
                                          ]);
                                    },
                                  ),
                                ))
                              : Text(""),
                ],
              ),
            ))));
  }
}
