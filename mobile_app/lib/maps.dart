import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/maps.dart';
import 'package:mobile_app/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

const List<String> collegeList = <String>['None', 'Lehigh'];

class Maps extends StatelessWidget {
  const Maps({super.key});

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

List<String> _lindermanList = [];
List<String> _fmlList = [];
List<String> _storeList = [];
List<File?> _lindermanImgList = [];
List<File?> _fmlImgList = [];
List<File?> _storeImgList = [];
List<bool> _lindermanImgBoolList = [];
List<bool> _fmlImgBoolList = [];
List<bool> _storeImgBoolList = [];
bool imgFlag = false;
String locValue = "Linderman Library";

class _MyHomePageState extends State<MyHomePage> {
  File? galleryFile;
  final picker = ImagePicker();

  Widget _buildPopupDialog(BuildContext context, locValue) {
    return AlertDialog(
      title: const Text('Comments'),
      content: Container(
          height: 400,
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: locValue == "Linderman Library"
                    ? _lindermanList.length
                    : locValue == "Fairchild-Martindale Library"
                        ? _fmlList.length
                        : locValue == "Lehigh Bookstore"
                            ? _storeList.length
                            : 1,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(locValue == "Linderman Library"
                            ? _lindermanList[index]
                            : locValue == "Fairchild-Martindale Library"
                                ? _fmlList[index]
                                : locValue == "Lehigh Bookstore"
                                    ? _storeList[index]
                                    : "HI :D"),
                      ]);
                },
              ),
            ],
          )),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
          child: const Text('Close'),
        ),
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildCommentDialog(context));
          },
          child: const Text('Add Comment'),
        ),
      ],
    );
  }

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

  Widget _buildCommentDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Comments'),
      content: Column(children: <Widget>[
        TextField(
          controller: cmntController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Comment Entry',
          ),
        ),
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
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
        )
      ]),
      actions: <Widget>[
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
          onPressed: () {
            setState(() {
              if (locValue == "Linderman Library") {
                setState(() {
                  _lindermanList.add(cmntController.text);
                  if (imgFlag) {
                    _lindermanImgList.add(galleryFile!);
                    _lindermanImgBoolList.add(true);
                    imgFlag = false;
                  } else {
                    _lindermanImgList.add(null);
                    _lindermanImgBoolList.add(false);
                  }
                  galleryFile = null;
                  cmntController.clear();
                });
              } else if (locValue == "Fairchild-Martindale Library") {
                setState(() {
                  _fmlList.add(cmntController.text);
                  if (imgFlag) {
                    _fmlImgList.add(galleryFile!);
                    _fmlImgBoolList.add(true);
                    imgFlag = false;
                  } else {
                    _fmlImgList.add(null);
                    _fmlImgBoolList.add(false);
                  }
                  galleryFile = null;
                  cmntController.clear();
                });
              } else {
                setState(() {
                  _storeList.add(cmntController.text);
                  if (imgFlag) {
                    _storeImgList.add(galleryFile!);
                    _storeImgBoolList.add(true);
                    imgFlag = false;
                  } else {
                    _storeImgList.add(null);
                    _storeImgBoolList.add(false);
                  }
                  galleryFile = null;
                  cmntController.clear();
                });
              }
            });
          },
          child: const Text('Add Entry'),
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

  Position _location = Position(latitude: 0, longitude: 0);
  String dropdownValue = collegeList.first;

  late GoogleMapController mapController;
  //this is the function to load custom map style json
  void changeMapMode(GoogleMapController mapController) {
    getJsonFile("lib/assets/map_style.json")
        .then((value) => setMapStyle(value, mapController));
  }

  //helper function
  void setMapStyle(String mapStyle, GoogleMapController mapController) {
    mapController.setMapStyle(mapStyle);
  }

  //helper function
  Future<String> getJsonFile(String path) async {
    ByteData byte = await rootBundle.load(path);
    var list = byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes);
    return utf8.decode(list);
  }

  final LatLng _center = const LatLng(40.6049, -75.3775);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _displayCurrentLocation() async {
    /*final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);*/
    final location = Position(latitude: 40.6049, longitude: -75.3775);
    _add(location.latitude, location.longitude, 'Your Location', true);

    setState(() {
      _location = location;
    });
  }

  void _add(lat, lng, id, yourLoc) {
    String markerIdVal = id;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          (yourLoc) ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed),
      onTap: () => {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialog(context, markerIdVal),
        )
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _addCollegeMarkers(college) {
    if (college == "Lehigh") {
      _add(40.60958556811076, -75.37811001464506, "Lehigh Bookstore", false);
      _add(40.60895596054946, -75.37787503466733,
          "Fairchild-Martindale Library", false);
      _add(40.60661885328797, -75.3773548234956, "Linderman Library", false);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    changeMapMode(mapController);
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
                            Icons.location_on,
                            size: 30.0,
                          ),
                          onPressed: () {
                            _displayCurrentLocation();
                          },
                        ),
                      ],
                    ),
                    Text("${_location.latitude}, ${_location.longitude}"),
                    Text("Change current college:"),
                    DropdownButton(
                      value: dropdownValue,
                      items: collegeList
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
                        _addCollegeMarkers(value!);
                      },
                    ),
                    SizedBox(
                        width: 500,
                        height: 500,
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 11.0,
                          ),
                          markers: Set<Marker>.of(markers.values),
                        )),
                  ],
                ),
              ),
            )));
  }
}
