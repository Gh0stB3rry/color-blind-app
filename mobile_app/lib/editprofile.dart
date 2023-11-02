import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Profile',
      home: const MyEditProfile(title: 'Edit Profile'),
    );
  }
}

class MyEditProfile extends StatefulWidget {
  const MyEditProfile({super.key, required this.title});

  final String title;

  @override
  State<MyEditProfile> createState() => _MyEditProfileState();
}

var user = FirebaseAuth.instance.currentUser!.email;

class _MyEditProfileState extends State<MyEditProfile> {
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController foodController = TextEditingController(text: '');
  TextEditingController vacController = TextEditingController(text: '');
  TextEditingController phoneController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  final picker = ImagePicker();

  File? tempFile;

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
            tempFile = File(pickedFile!.path);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Profile',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen.shade200,
          title: Center(
            child: const Text('Edit Profile'),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade300, Colors.indigo.shade300],
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        child: tempFile == null
                            ? IconButton(
                                onPressed: () {
                                  _showPicker(context: context);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  size: 30.0,
                                ))
                            : CircleAvatar(
                                radius: 30.0,
                                backgroundImage: FileImage(tempFile!),
                                child: IconButton(
                                    onPressed: () {
                                      _showPicker(context: context);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 30.0,
                                    ))),
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
                          Icons.check,
                          size: 30.0,
                        ),
                        onPressed: () async {
                          phoneController.text != ''
                              ? await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user)
                                  .update({'phone': phoneController.text})
                              : '';
                          foodController.text != ''
                              ? await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user)
                                  .update({'food': foodController.text})
                              : '';
                          vacController.text != ''
                              ? await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user)
                                  .update({'vacation': vacController.text})
                              : '';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Profile()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    user!,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.deepOrange.shade300,
                      child: ListTile(),
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
                      'Phone Number',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: TextField(
                      controller: phoneController,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Favorite Food',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: TextField(
                      controller: foodController,
                      style: TextStyle(
                        fontSize: 15,
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
                    subtitle: TextField(
                      controller: vacController,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
