import 'dart:math';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

//importing firebase and firebase store.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


//group type for creating groups

var available_types = ['Public', 'Private'];
//var _groupEntry = [false, false, false, false, false];
var _groupEntry = [];
var _pubpriv = false;
var userType = FirebaseAuth.instance.currentUser;
//var url = "https://my.clevelandclinic.org/health/diseases/11604-color-blindness";


class Groups extends StatelessWidget {
  const Groups({super.key});

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


  List<String> urls = [
    "https://www.colourblindawareness.org/#:~:text=Welcome%20to%20Colour%20Blind%20Awareness",
    "https://enchroma.com/"
  ];
  TextEditingController cmntController = TextEditingController();
  TextEditingController descController = TextEditingController();

  //For group type
  String? group_type;

  //created new group with firebase firestore
  //will include the values of example as well

  List<List<String>> _groupList = [];

  //get the group
  Future<List<List<String>>> groupGet() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('groups').get();
    //QuerySnapshot colorSnapshot = await firestore.collection('users').get();
    //print()
    //print(user);

    
    
    var _groupEntry1 = [];
    List<List<String>> fullGroup = [];
    //first get the groups from the firestore database
    for (var doc in querySnapshot.docs){
      bool emailFound = false;
      String name = doc['name'];
      String type = doc['type'];
      String creator = doc['creator'];
      String description = doc['description'];
      String url = doc['url'];

      List<String> tempGroup = [];
        tempGroup.add(name);
        tempGroup.add(type);
        tempGroup.add(creator);
        tempGroup.add(description);
        tempGroup.add(url);
        
      var emailCollection = FirebaseFirestore.instance
          .collection('groups')
          .doc(doc.id)
          .collection('users');
      QuerySnapshot querySnapshot2 = await emailCollection.get();


      


      //if the type is public  
      if (type == 'Public') {
        for (var doc2 in querySnapshot2.docs){
          String emailData = doc2['email'];
          if(emailData == auth!.email!.trim()){
            emailFound = true;
          }  
        }
        _groupEntry1.add(emailFound);
        fullGroup.add(tempGroup);
      }

      //if the type is private
      else {
        for (var doc2 in querySnapshot2.docs){
          String emailData = doc2['email'];
          if(emailData == auth!.email!.trim()){
            emailFound = true;
            fullGroup.add(tempGroup);
          }
          
        }
        _groupEntry1.add(emailFound);
      }
      
    }
    _groupEntry = _groupEntry1;
    print("Look at the entry");
    print(_groupEntry);
    return fullGroup;
  }

  void joinAdd(index) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('groups').get();
    var count = 0; //counter for the document we are adding it to 
    bool emailCheck = false; //bool for checking if email already exists
    for (var doc in querySnapshot.docs){
      if(count == index){
        var emailCollection = FirebaseFirestore.instance
          .collection('groups')
          .doc(doc.id)
          .collection('users');
        QuerySnapshot querySnapshot2 = await emailCollection.get();

        for (var doc2 in querySnapshot2.docs){ //checks through users
            String emailData = auth!.email!.trim();
            if(emailData == doc2['email']){//if email found
                emailCheck = true;
            }
        }
        if(emailCheck == false){ //if user email was not found: add user
          emailCollection.add({
            'email': auth!.email!.trim(),
          });

          
        }

      }
      
      count = count + 1;
    }


  }

  @override
  void initState(){
    super.initState();
    groupGet().then((group) {
      setState((){
        _groupList = group;
      });
    });
  }



  //FirebaseFirestore firestore = FirebaseFirestore.instance;
  //QuerySnapshot querySnapshot = firestore.collection('groups').get();


  //var group = [];
  //var _groupList1 = FirebaseFirestore.instance
  //  .collection('groups').get();
  //var _groupList2 = _groupList1.get();
  //group example
  /*
    var _groupList = [
    [
      "First group :)", 
      "Public", 
      "leh3003@wellcoach.org",
      "my first group, seeing how it works"
    ],
    [
      "Bookstores!!",
      "Public",
      "mat202@wellcoach.org",
      "A group for all who love bookstores!!"
    ],
    [
      "Libraries enjoyers",
      "Public",
      "lem111@wellcoach.org",
      "I like books. Do you?"
    ]
  ];
  
*/
  

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Group Creation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: cmntController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Group Name',
            ),
          ),
          SizedBox(height: 5),
          TextField(
            maxLines: null,
            controller: descController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),
          SizedBox(height: 5),

          //added type of group
          Text("Choose group type:",
              style: TextStyle(color: Colors.indigo.shade500),
              ),
          DropdownButton(
            value: group_type,
            hint: Text('Select type'),
            items: <String>[
                'Public',
                'Private',
                
            ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
                );
                      }).toList(),
                    onChanged: (String? newValue) {
                      group_type = newValue;
                      setState(() {
                        group_type;
                      });
                            
                    },
              ),

        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
          // add the newly created group to the group list dropdown option (public private) auth!.email
          // your codes begin here

          
          //add instance within groups collection
          var fireInstance = FirebaseFirestore.instance.collection('groups');
          fireInstance.add({
            'name': cmntController.text.trim(),
            'type': group_type,
            'creator': auth!.email!.trim(),
            'description': descController.text.trim()
          }).then((docRef){
            fireInstance.doc(docRef.id).collection('users').add({
              'email': auth!.email!.trim()
            });
          });

          

          

          //exit out after pressing button
          Navigator.of(context).pop();

          // end
          },
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
          child: const Text('Create'),
        ),
        ElevatedButton(
          onPressed: () {
            cmntController.clear();
            descController.clear();
            Navigator.of(context).pop();
          },
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildGroupDialog(BuildContext context, index) {
    return AlertDialog(
      title: const Text('Resource Description'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_groupList[index][3], //3
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12))
        ],
      ),
      actions: <Widget>[
        ///////////////////////////////////////////////////////////////////////////
        ElevatedButton(
          ///////////////////////////////////////////////////////
          onPressed: ()async{
            final Uri url2 = Uri.parse(_groupList[index][4]); //_groupList[index][4] //urls[index]
            
            if (await canLaunchUrl(url2)){
              await launchUrl(url2,
              mode:LaunchMode.externalApplication,
              );
            } else {
              throw 'Could not use the url';
            }

          },
          //////////////////////////////
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade300),
          child: const Text('Url'),
        ),
        //////////////////////////////////////////////////////////////////////////
        
        ElevatedButton(
          onPressed: () {
            // your codes begin here
            Navigator.of(context).pop();

            // end
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
                          /*
                          SizedBox(width: 60),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo.shade300),
                            child: const Text('Add a resource'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context),
                              );
                            },
                          ),*/
                        ],
                      ),
                      
                      SizedBox(height: 20),
                      Text(
                        "Resources for color blind assistance",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.indigo.shade300),
                      ),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                height: 30,
                                width: 380,
                                alignment: Alignment.center,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                          width: 95,
                                          child: Text(
                                            "Name",
                                            style: TextStyle(
                                                color: Colors.indigo.shade500),
                                          )),
                                      Container(
                                          width: 75,
                                          child: Text(
                                            "",
                                            style: TextStyle(
                                                color: Colors.indigo.shade500),
                                          )),
                                          
                                      Container(
                                          width: 110,
                                          child: Text(
                                            "",
                                            style: TextStyle(
                                                color: Colors.indigo.shade500),
                                          )),
                                      Container(width: 95, child: Text("")),
                                      
                                    ])),
                          ]),
                      Divider(color: Colors.black),
                      Expanded(
                          child: SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _groupList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      height: 80,
                                      width: 380,
                                      alignment: Alignment.center,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                                width: 95,
                                                child: Text(
                                                  _groupList[index][0],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors
                                                          .indigo.shade500),
                                                )),
                                            Container(
                                                width: 50,
                                                child: Text(
                                                  '',//_groupList[index][1],
                                                  style: TextStyle(
                                                      color: Colors
                                                          .indigo.shade500),
                                                )),
                                                
                                            Container(
                                                width: 110,
                                                child: Text(
                                                  "",//_groupList[index][2],
                                                  style: TextStyle(
                                                      color: Colors
                                                          .indigo.shade500),
                                                )),
                                                
                                            Container(
                                              width: 95,
                                              child: _groupEntry[index] == false
                                                  ? _groupList[index][1] ==
                                                          "Public"
                                                      ? ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .indigo
                                                                          .shade300),
                                                          child: Text(
                                                              'info',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      12)),
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  _buildGroupDialog(
                                                                      context,
                                                                      index),
                                                            );
                                                          },
                                                        )
                                                      : ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .indigo
                                                                          .shade300),
                                                          child:
                                                              Icon(Icons.check),
                                                          onPressed: () => {},
                                                        )
                                                  : ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.indigo
                                                                      .shade300),
                                                      child: Icon(Icons.check),
                                                      onPressed: () => {},
                                                    ),
                                            )
                                          ])),
                                ]);
                          },
                        ),
                      ))
                    ],
                  ),
                )))));
  }
}
