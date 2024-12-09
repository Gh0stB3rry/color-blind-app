import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/achievements.dart';
import 'package:mobile_app/editprofile.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/users.dart';
import 'package:mobile_app/main.dart'; //added for project 1

class Profile extends StatelessWidget {
  const Profile({super.key});

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

var user = FirebaseAuth.instance.currentUser;

void signout() async{
   //user!.signOut();
  await FirebaseAuth.instance.signOut();
}


class _MyHomePageState extends State<MyHomePage> {
  Future<List<Object?>> func() async {
    
    print(user!.email);
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user!.email)
        .get();
    final allData = snap.docs.map((doc) => doc.data()).toList();
    return allData;
  }


  //function sign out added to actually sign email out
  //Project 1
  Future<void> signOutEmail() async{
    await FirebaseAuth.instance.signOut();
  }
  


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Profile',
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightGreen.shade200,
            title: Center(
              child: const Text('Profile'),
            ),
          ),
          body: SafeArea(
            child: FutureBuilder(
                future: func(),
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
                      print("Look at this data");
                      print(snapshot);
                      print(snapshot.data!);
                      return ListView(
                        children: <Widget>[
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.indigo.shade300,
                                  Colors.indigo.shade300
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [0.5, 0.9],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.lightGreen.shade300,
                                        minimumSize: Size(64, 64),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            side: BorderSide(
                                                color: Colors
                                                    .lightGreen.shade300)),
                                      ),
                                      child: Icon(
                                        Icons.home,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Home()),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.lightGreen.shade300,
                                        minimumSize: Size(64, 64),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            side: BorderSide(
                                                color: Colors
                                                    .lightGreen.shade300)),
                                      ),
                                      child: Icon(
                                        Icons.priority_high_rounded,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Achievements()),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.lightGreen.shade300,
                                        minimumSize: Size(64, 64),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            side: BorderSide(
                                                color: Colors
                                                    .lightGreen.shade300)),
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const EditProfile()),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  (snapshot.data!.elementAt(0) as Map)['email']
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Color Blind Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),

                                //Sign out button
                                //Project 1 Week 2
                                SizedBox(width: 10),
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
                                    Icons.logout,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    signout();
                                    Navigator.push(
                                      context,                                      
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              //change this
                                              //user1 = user.signOut(),
                                              
                                              const MyApp()),
                                            
                                    );
                                  },
                                ),

                                ///
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    color: Colors.deepOrange.shade300,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.deepOrange.shade300,
                                            shadowColor: null),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Users()),
                                          );
                                        },
                                        child: Text(
                                          "Friends",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    'Email',
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    (snapshot.data!.elementAt(0)
                                            as Map)['email']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Divider(),
                                ListTile(
                                  title: Text(
                                    'Type of Color Blindness',
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    (snapshot.data!.elementAt(0)
                                            as Map)['colorBlindType']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                
                                Divider(),
                                /*
                                ListTile(
                                  title: Text(
                                    'Favorite Food',
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    (snapshot.data!.elementAt(0) as Map)['food']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Divider(), //cut here for more colums
                                ListTile(
                                  title: Text(
                                    'Dream Vacation',
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    (snapshot.data!.elementAt(0)
                                            as Map)['vacation']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                                */
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ));
  }
}
