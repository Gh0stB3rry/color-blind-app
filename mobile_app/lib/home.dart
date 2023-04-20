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
import 'package:mobile_app/help.dart';
import 'package:mobile_app/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'journal.dart';

const List<String> collegeList = <String>['None', 'Lehigh'];

class Home extends StatelessWidget {
  const Home({super.key});

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
DateTime _lindermanTime = DateTime.parse("2000-01-01");
DateTime _fmlTime = DateTime.parse("2000-01-01");
DateTime _storeTime = DateTime.parse("2000-01-01");
bool imgFlag = false;

class _MyHomePageState extends State<MyHomePage> {
  File? galleryFile;
  final picker = ImagePicker();

  Widget _buildPopupDialog(BuildContext context, locValue) {
    return AlertDialog(
      title: Text(locValue + " Comments"),
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
                        locValue == "Linderman Library"
                            ? _lindermanImgBoolList[index]
                                ? Container(
                                    height: 150,
                                    width: 130,
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child:
                                        Image?.file(_lindermanImgList[index]!),
                                  )
                                : SizedBox(width: 130)
                            : locValue == "Fairchild-Martindale Library"
                                ? _fmlImgBoolList[index]
                                    ? Container(
                                        height: 150,
                                        width: 130,
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Image?.file(_fmlImgList[index]!),
                                      )
                                    : SizedBox(width: 130)
                                : _storeImgBoolList[index]
                                    ? Container(
                                        height: 150,
                                        width: 130,
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child:
                                            Image?.file(_storeImgList[index]!),
                                      )
                                    : SizedBox(width: 130)
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
                    _buildCommentDialog(context, locValue));
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

  Widget _buildCommentDialog(BuildContext context, locValue) {
    return AlertDialog(
      title: const Text('Add a Comment'),
      content: Container(
          height: 300,
          width: 150,
          child: Column(children: <Widget>[
            TextField(
              controller: cmntController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Comment Entry',
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
          ])),
      actions: <Widget>[
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
          onPressed: () {
            setState(() {
              if (locValue == "Linderman Library") {
                setState(() {
                  _lindermanList.add(cmntController.text);
                  _lindermanTime = DateTime.now();
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
                  _fmlTime = DateTime.now();
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
                  _storeTime = DateTime.now();
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
              markers.clear();
              _add(40.60958556811076, -75.37811001464506, "Lehigh Bookstore",
                  false);
              _add(40.60895596054946, -75.37787503466733,
                  "Fairchild-Martindale Library", false);
              _add(40.60661885328797, -75.3773548234956, "Linderman Library",
                  false);
            });
          },
          child: const Text('Add Entry'),
        ),
        ElevatedButton(
          onPressed: () {
            galleryFile = null;
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
      infoWindow: InfoWindow(title: markerIdVal),
      icon: BitmapDescriptor.defaultMarkerWithHue((yourLoc)
          ? BitmapDescriptor.hueGreen
          : markerIdVal == "Linderman Library"
              ? _lindermanTime.year == DateTime.now().year
                  ? _lindermanTime.month == DateTime.now().month
                      ? _lindermanTime.day == DateTime.now().day
                          ? BitmapDescriptor.hueAzure
                          : BitmapDescriptor.hueCyan
                      : BitmapDescriptor.hueBlue
                  : BitmapDescriptor.hueBlue
              : markerIdVal == "Fairchild-Martindale Library"
                  ? _fmlTime.year == DateTime.now().year
                      ? _fmlTime.month == DateTime.now().month
                          ? _fmlTime.day == DateTime.now().day
                              ? BitmapDescriptor.hueAzure
                              : BitmapDescriptor.hueCyan
                          : BitmapDescriptor.hueBlue
                      : BitmapDescriptor.hueBlue
                  : markerIdVal == "Lehigh Bookstore"
                      ? _storeTime.year == DateTime.now().year
                          ? _storeTime.month == DateTime.now().month
                              ? _storeTime.day == DateTime.now().day
                                  ? BitmapDescriptor.hueAzure
                                  : BitmapDescriptor.hueCyan
                              : BitmapDescriptor.hueBlue
                          : BitmapDescriptor.hueBlue
                      : BitmapDescriptor.hueBlue),
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

  List<String> items = [
    "Journal",
    "Profile",
  ];

  /// List of body icon
  List<IconData> icons = [
    Icons.home,
    Icons.explore,
    Icons.settings,
    Icons.person
  ];
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Location",
        home: Scaffold(
            backgroundColor: Colors.lightGreen[100],
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.indigo.shade300,
              title: Text(
                "Home Page",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/assets/beach.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                width: double.infinity,
                height: double.infinity,
                margin: const EdgeInsets.all(5),
                child: Column(children: [
                  SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 117,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextButton(
                                child: Text(
                                  items[0],
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.indigo.shade300),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Journal()));
                                },
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white54,
                              minimumSize: Size(30, 30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(color: Colors.white54)),
                            ),
                            child: Icon(
                              Icons.question_mark,
                              size: 15.0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Help()),
                              );
                            },
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 117,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextButton(
                                child: Text(
                                  items[1],
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.indigo.shade300),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Profile()));
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                  Text(
                    Random().nextInt(2) == 0
                        ? "\"You have an individual story to tell\""
                        : "\"Find happiness in the darkest times\"",
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.indigo.shade300),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Change current college:",
                          style:
                              GoogleFonts.lato(color: Colors.indigo.shade500),
                        ),
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
                ]))));
  }
}
