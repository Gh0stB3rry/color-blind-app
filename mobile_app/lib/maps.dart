import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/comments.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/maps.dart';
import 'package:mobile_app/profile.dart';

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

class _MyHomePageState extends State<MyHomePage> {
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
    var markerIdVal = id;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          (yourLoc) ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed),
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Comments()),
                        );
                      },
                      child: const Text('Comments'),
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
