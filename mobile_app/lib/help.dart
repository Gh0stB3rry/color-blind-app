import 'package:flutter/material.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);
  static const String _title = 'Help';

  Widget _buildJournalDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Journaling'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "If you want to leave a priviate message in the journal, click the journal button on the upper-left corner.\n\nThis will allow you to leave a priviate message or image. This records the date and your location as well!",
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

  Widget _buildProfileDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "To edit your profile, click on the \'profile\' button, and then the pencil button to make any changes to your personal interests!",
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

  Widget _buildMapDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Maps and Commenting'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'If you want to record a message or image for others to see, click the drop down button on the home screen to find your college.\nAfter, find the location you want to blog about and click its icon.\nHere you can see other comments and add your own.',
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
            // and so on for every text style
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 90),
                          Text(
                            "Help",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.indigo.shade300),
                          ),
                          SizedBox(width: 50),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreen.shade300,
                              minimumSize: Size(128, 64),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(
                                      color: Colors.lightGreen.shade300)),
                            ),
                            child: Icon(
                              Icons.arrow_forward,
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
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            '\nThis is our app where we want to make mental health accessible to everyone!\n\nENJOY!',
                            style: TextStyle(fontSize: 20),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo.shade300),
                            child: Text('How to Journal',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildJournalDialog(context),
                              );
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo.shade300),
                            child: Text('Maps and Commenting',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildMapDialog(context),
                              );
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo.shade300),
                            child: Text('Profile Editing',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildProfileDialog(context),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )))));
  }
}
