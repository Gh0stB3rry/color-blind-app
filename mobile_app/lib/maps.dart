import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/comments.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/maps.dart';

class Maps extends StatelessWidget {
  const Maps({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile App',
      theme: ThemeData(
        primarySwatch: Colors.red,
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

  late GoogleMapController mapController;
  final LatLng _center = const LatLng(40.6049, -75.3775);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _displayCurrentLocation() async {
    /*final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);*/
    final location = Position(latitude: 40.6049, longitude: -75.3775);
    _add(location.latitude, location.longitude);

    setState(() {
      _location = location;
    });
  }

  void _add(lat, lng) {
    var markerIdVal = "test";
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Location",
        home: Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("${_location.latitude}, ${_location.longitude}"),
              ElevatedButton(
                child: Text("Find Current Location",
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _displayCurrentLocation();
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Comments()),
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
        )));
  }
}
