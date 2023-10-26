import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/dailies.dart';
import 'package:mobile_app/exercise.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/help.dart';
import 'package:mobile_app/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'groups.dart';
import 'journal.dart';

const List<String> collegeList = <String>[
  'None',
  'Lehigh University',
  'Colgate University',
  'Bucknell University'
];

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

num _lindermanFeel = -1;
num _fmlFeel = -1;
num _storeFeel = -1;
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
var auth = FirebaseAuth.instance.currentUser;

class _MyHomePageState extends State<MyHomePage> {
  File? galleryFile;
  final picker = ImagePicker();

  Widget _buildDisplayDialog(BuildContext context, data) {
    return AlertDialog(
      title: Text(data['user'].toString() + '\'s comment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(data['data'],
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))
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

  Future<List<Object?>> getComments(locValue) async {
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('comments')
        .doc(locValue)
        .collection("comments");

    QuerySnapshot querySnapshot = await _collectionRef.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  Widget _buildPopupDialog(BuildContext context, locValue) {
    return AlertDialog(
      title: Text(locValue + " Comments"),
      scrollable: true,
      contentPadding: EdgeInsets.all(1),
      content: Container(
          height: 400,
          width: 150,
          child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: TextStyle(fontSize: 18),
                      ),
                    );

                    // if we got our data
                  } else if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            List<bool> _likes =
                                List.filled(snapshot.data!.length, false);
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: (snapshot.data!
                                                            .elementAt(index)
                                                        as Map)['feel'] ==
                                                    "b"
                                                ? Colors.red
                                                : (snapshot.data!.elementAt(
                                                                index)
                                                            as Map)['feel'] ==
                                                        "n"
                                                    ? Colors.yellow
                                                    : Colors.green,
                                            minimumSize: Size(10, 10),
                                            shape: CircleBorder(
                                                side: BorderSide(
                                                    color: Colors.white54)),
                                          ),
                                          child: Text(""),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: _likes[index]
                                              ? Icon(Icons.thumb_up_alt,
                                                  size: 16)
                                              : Icon(Icons.thumb_up_alt,
                                                  color: Colors.blue, size: 16),
                                          onPressed: () {
                                            setState(() {
                                              _likes[index] = !_likes[index];
                                            });
                                            print(_likes[index]);
                                          },
                                        ),
                                        Text(""),
                                        Container(
                                          child: Text(
                                            (snapshot.data!.elementAt(index)
                                                as Map)['user'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          width: 90,
                                        ),
                                        SizedBox(width: 5),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.indigo.shade300),
                                          child: Text('Show Message',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12)),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildDisplayDialog(
                                                      context,
                                                      snapshot.data!
                                                          .elementAt(index)),
                                            );
                                          },
                                        ),
                                        /*locValue == "Linderman Library"
                                      ? _lindermanImgBoolList[index]
                                          ? Container(
                                              height: 150,
                                              width: 100,
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Image?.file(
                                                  _lindermanImgList[index]!),
                                            )
                                          : SizedBox(width: 100)
                                      : locValue ==
                                              "Fairchild-Martindale Library"
                                          ? _fmlImgBoolList[index]
                                              ? Container(
                                                  height: 150,
                                                  width: 100,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8),
                                                  child: Image?.file(
                                                      _fmlImgList[index]!),
                                                )
                                              : SizedBox(width: 100)
                                          : _storeImgBoolList[index]
                                              ? Container(
                                                  height: 150,
                                                  width: 100,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8),
                                                  child: Image?.file(
                                                      _storeImgList[index]!),
                                                )
                                              : SizedBox(width: 100)*/
                                      ]),
                                ]);
                          },
                        ),
                      ],
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              future: getComments(locValue))),
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
    String? selectedTone; // To store the selected tone

    return AlertDialog(
      title: const Text('Add a Comment'),
      content: Container(
          height: 370, // Adjusted the height to fit the new widget
          width: 150,
          child: Column(
            children: <Widget>[
              TextField(
                controller: cmntController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Comment Entry',
                ),
              ),
              SizedBox(height: 10), // Spacing
              DropdownButton<String>(
                value: selectedTone,
                hint: Text('Select Comment Tone'),
                items: <String>[
                  'Positive',
                  'Negative',
                  'Neutral', // Added Neutral option
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTone = newValue;
                  });
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade300),
                child: const Text('Select Image'),
                onPressed: () {
                  _showPicker(context: context);
                },
              ),
            ],
          )),
      actions: <Widget>[
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
          onPressed: () {
            if (selectedTone != null) {
              String feelValue;
              if (selectedTone == 'Positive') {
                feelValue = 'g';
              } else if (selectedTone == 'Negative') {
                feelValue = 'b';
              } else {
                feelValue = 'n'; // Value for Neutral
              }

              FirebaseFirestore.instance
                  .collection("comments")
                  .doc(locValue)
                  .collection("comments")
                  .add({
                'data': cmntController.text,
                'user': auth!.email,
                'feel': feelValue,
              });
              setState(() {});
            } else {
              // Handle case when no tone is selected (Maybe show a snackbar or alert)
            }
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

  Position _location = Position(
      latitude: 0,
      longitude: 0,
      speed: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      speedAccuracy: 0,
      heading: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0);
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
    final location = await Geolocator.getCurrentPosition();
    /*final location = Position(
        latitude: 40.6049,
        longitude: -75.3775,
        speed: 0,
        timestamp: null,
        accuracy: 0,
        altitude: 0,
        speedAccuracy: 0,
        heading: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0);*/
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
          ? BitmapDescriptor.hueBlue
          : markerIdVal == "Linderman Library"
              ? _lindermanFeel <= 0.7 && _lindermanFeel >= 0
                  ? BitmapDescriptor.hueRed
                  : _lindermanFeel <= 1.3 && _lindermanFeel >= 0
                      ? BitmapDescriptor.hueYellow
                      : _lindermanFeel <= 2 && _lindermanFeel >= 0
                          ? BitmapDescriptor.hueGreen
                          : BitmapDescriptor.hueOrange
              : markerIdVal == "Fairchild-Martindale Library"
                  ? _fmlFeel <= 0.5 && _fmlFeel >= 0
                      ? BitmapDescriptor.hueRed
                      : _fmlFeel <= 1.2 && _fmlFeel >= 0
                          ? BitmapDescriptor.hueYellow
                          : _fmlFeel <= 2 && _fmlFeel >= 0
                              ? BitmapDescriptor.hueGreen
                              : BitmapDescriptor.hueOrange
                  : markerIdVal == "Lehigh Bookstore"
                      ? _storeFeel <= 0.5 && _storeFeel >= 0
                          ? BitmapDescriptor.hueRed
                          : _storeFeel <= 1.2 && _storeFeel >= 0
                              ? BitmapDescriptor.hueYellow
                              : _storeFeel <= 2 && _storeFeel >= 0
                                  ? BitmapDescriptor.hueGreen
                                  : BitmapDescriptor.hueOrange
                      : BitmapDescriptor.hueOrange),
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

  void _addCollegeMarkers(college) async {
    if (college == "Lehigh University") {
      await FirebaseFirestore.instance
          .collection("locations")
          .doc("WxvETSn4QSafEChiz5sy")
          .get()
          .then((snapshot) => print(snapshot.data()?["college"]));
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
                style: TextStyle(
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 85,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextButton(
                                child: Text(
                                  "Journal",
                                  style: TextStyle(
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
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 85,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextButton(
                                child: Text(
                                  "Activities",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.indigo.shade300),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Dailies()));
                                },
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 85,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextButton(
                                child: Text(
                                  "Groups",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.indigo.shade300),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Groups()));
                                },
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 85,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextButton(
                                child: Text(
                                  "Profile",
                                  style: TextStyle(
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
                    style: TextStyle(
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
                          style: TextStyle(color: Colors.indigo.shade500),
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
                            _displayCurrentLocation();
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
