import 'package:flutter/material.dart';
import 'package:mobile_app/dailies.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_app/profile.dart';

class Achievements extends StatelessWidget {
  const Achievements({Key? key}) : super(key: key);
  static const String _title = 'Achievements';

  Widget _buildProfileDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Progressive muscle relaxation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Get into a comfortable position, either sitting or lying down.\2. Strive to tense and then release each large muscle or muscle group for about five seconds or so, then relax the muscles.\n3. Begin by taking a few deep breaths from the abdomen. Tense, hold, and relax each large muscle group, working your way up or down the body.\n4. Try and notice the contrast between a tensed state and a relaxed state inhaling as you tense the muscle and exhaling as you relax and let go.",
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.indigo,
          ),
        ),
        title: _title,
        home: Scaffold(
            appBar: AppBar(title: const Text(_title)),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(width: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightGreen.shade300,
                                    minimumSize: Size(64, 64),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        side: BorderSide(
                                            color: Colors.lightGreen.shade300)),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Profile()),
                                    );
                                  },
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightGreen.shade300,
                                    minimumSize: Size(64, 64),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        side: BorderSide(
                                            color: Colors.lightGreen.shade300)),
                                  ),
                                  child: Icon(
                                    Icons.timer,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildProfileDialog(context),
                                    );
                                  },
                                ),
                                SizedBox(width: 20),
                              ]),
                        ],
                      ),
                      SizedBox(height: 100),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo.shade300,
                                    minimumSize: Size(128, 64),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        side: BorderSide(
                                            color: Colors.indigo.shade300)),
                                  ),
                                  child: Icon(
                                    Icons.accessibility_new_rounded,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildProfileDialog(context),
                                    );
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo.shade300,
                                    minimumSize: Size(128, 64),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        side: BorderSide(
                                            color: Colors.indigo.shade300)),
                                  ),
                                  child: Icon(
                                    Icons.add_business_outlined,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildProfileDialog(context),
                                    );
                                  },
                                ),
                              ]),
                          SizedBox(height: 20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo.shade300,
                                    minimumSize: Size(128, 64),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        side: BorderSide(
                                            color: Colors.indigo.shade300)),
                                  ),
                                  child: Icon(
                                    Icons.add_comment_rounded,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildProfileDialog(context),
                                    );
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo.shade300,
                                    minimumSize: Size(128, 64),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        side: BorderSide(
                                            color: Colors.indigo.shade300)),
                                  ),
                                  child: Icon(
                                    Icons.battery_charging_full_rounded,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildProfileDialog(context),
                                    );
                                  },
                                ),
                              ]),
                        ],
                      ),
                    ],
                  ),
                )))));
  }
}
