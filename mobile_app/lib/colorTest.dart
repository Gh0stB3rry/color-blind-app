import 'package:flutter/material.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/Question.dart';
import 'dart:math';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/colorTestQuestionWidget.dart';

var user = FirebaseAuth.instance.currentUser;
var firebase = FirebaseFirestore.instance;
class colorTest extends StatelessWidget{
  const colorTest({super.key});

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

////////////////////////////////////////////////
//Class for next button
class nextQuestion extends StatelessWidget {
  const nextQuestion({Key? key, required this.futureQuestion}): super(key:key);
  final VoidCallback futureQuestion;

  @override
  Widget build(BuildContext context ){
    //GestureDetector optional as it requires touch capabilities
    
    return GestureDetector(
      onTap: futureQuestion,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0)
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
        'Next Question', 
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}
////////////////////////////////////////////


///////////////////////////////////////////////
///class for Card choices
class QuestionInput extends StatelessWidget {
  const QuestionInput({Key? key, required this.input, required this.color,}) : super(key:key);
  final String input;
  
  final Color color;
  @override
  Widget build(BuildContext context){
    //Gesture Detector makes it easy to press
    return Card(
      color: color,
        child: ListTile(
          title:Text(
            input, 
            style: TextStyle(
              fontSize:22.0,
              color: color.red != color.green  ? Colors.grey : Colors.black,
            ),
          ),
        ),
        );
  }
}
//////////////////////////////////////////////




////////////////////////////////////////////////////////////////
/// Class for results screen
class Results extends StatelessWidget {
  const Results ({Key ? key, required this.result, required this.lengthQuestion, required this.vision}) : super(key : key);
  final int result;
  final int lengthQuestion;
  final String vision;
  
  @override
  Widget build(BuildContext context){
    return AlertDialog(
      backgroundColor: Colors.blue,
      content: Padding(
          padding:const EdgeInsets.all(70.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Text(
              vision, 
              style: TextStyle(color: Colors.white, fontSize: 22.0),
              ),
              const SizedBox(height:20.0),
              CircleAvatar(
                
                radius: 60.0,
                backgroundColor: result == lengthQuestion? Colors.lightGreen : result < lengthQuestion/2 ? Colors.orange : result == lengthQuestion/2? Colors.yellow : Colors.orange,
                child: Text('$result/$lengthQuestion', style: TextStyle(fontSize:30.0)),
              )
            ],
          ),
        ),
    );
  }
  
}
///////////////////////////////////////////////////////////////

class _MyHomePageState extends State<MyHomePage> {
  // Has it been pressed or checked
  bool alreadySelected = false;
  //score points
  int score = 0;
  //index for questions
  int index = 0;
  //bool for button being clicked
  bool clicked = false;

  //result string
  String resultString = '';
  //List of Questions
  List<Question> _questions = [
    Question(
      id:'10',
      title: 'What number do you see?',
      options: {'5':false, '30':false, '47':true},
    ),
    Question(
      id:'11',
      title: 'What number do you see?',
      options: {'12':false, '19':true, '20':false},
    ),
    Question(
      id:'12',
      title: 'What number do you see?',
      options: {'51':true, '10':false, '67':false},
    ),
    Question(
      id:'13',
      title: 'What number do you see?',
      options: {'92':true, '32':false, '25':false},
    ),
    Question(
      id:'14',
      title: 'What number do you see?',
      options: {'78':false, '30':false, '69':true},
    ),
    Question(
      id:'15',
      title: 'What number do you see?',
      options: {'78':false, '75':true, '49':false},
    ),
    Question(
      id:'16',
      title: 'What number do you see?',
      options: {'15':false, '25':false, '8':true},
    ),
    
    Question(
      id:'17',
      title: 'What number do you see?',
      options: {'42':true, '29':false, '47':false},
    ),
    Question(
      id:'18',
      title: 'What number do you see?',
      options: {'97':false, '37':true, '27':false},
    ),
    Question(
      id:'19',
      title: 'What number do you see?',
      options: {'88':false, '25':true, '69':false},
    ),
    Question(
      id:'20',
      title: 'What number do you see?',
      options: {'35':false, '78':false, '98':true},
    ),
    Question(
      id:'21',
      title: 'What number do you see?',
      options: {'35':false, '78':false, '28':true},
    ),
    
  ];

 List<String> coloredImages = [
  "lib/colorImages/redGreen47.png",
  "lib/colorImages/redGreen19.png",
  "lib/colorImages/redGreen51.png",
  "lib/colorImages/redGreen92.png",
  "lib/colorImages/redGreen69.png",
  "lib/colorImages/redGreen75.png",
  "lib/colorImages/redGreen8.png",
  "lib/colorImages/redGreen42.png",
  "lib/colorImages/redGreen37.png",
  "lib/colorImages/redGreen25.png",
  "lib/colorImages/redGreen98.png",
  "lib/colorImages/redGreen28.png"

 ];
  //function for calling the next question 
  void futureQuestion(){
    if(index == _questions.length -1){
      if(score < 11){
        resultString = 'Red-Green Color blindness';
      } else{
        resultString = "Perfect Vision";
      }
      updateVisionStatus();
      showDialog(context: context, builder:(ctx) => Results(
        result: score,
        lengthQuestion: _questions.length,
        vision: resultString
        )
      );

      //changing the data field for 
    } else{
      if(clicked){      
        setState((){
          index++;
          clicked = false;
          alreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select any option'), 
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical:20.0))
        );
      }
    }
  }

  //function for when button is pressed
  void answerChecker(bool value){
    if (alreadySelected){
      return;
    } else {

    
        if (value == true){
          score++;
          setState(() {
            clicked = true;
            alreadySelected = true;
          });
        }
        else {
          setState(() {
            clicked = true;
            alreadySelected = true;
          });
        }
    }
  }

  // function for updating the firebase user
  void updateVisionStatus() async {
    
      try{
        QuerySnapshot query = await firebase
          .collection('users')
          .where('email',isEqualTo: user!.email)
          .get();
        for (var doc in query.docs){
          if (resultString == 'Red-Green Color blindness'){
            await firebase.collection('users').doc(doc.id).update({'colorBlindType': 'red-green'});
          }
          else {
            await firebase.collection('users').doc(doc.id).update({'colorBlindType': 'Perfect'});
          }
        }

      } catch(e){
        print('Failed to get user vision data');
      }
    

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Color Blind Test",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: const Text('color test'),
          backgroundColor: const Color.fromRGBO(255, 193, 7, 1),
          
          actions: [
            ///////////////
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
            /////////////
            Padding(padding: const EdgeInsets.all(18.0), 
                    child: 
                      Text('Score: $score', style: const TextStyle(fontSize: 18.0),
                    ),
                    
            ),
          ],

        ),
      
      
      
      body: Container(
        width: double.infinity,
        child:  Column(
          children: [
            
            colorTestQuestionWidget(
              question: _questions[index].title, 
              indexAction: index, 
              totalQuestions: _questions.length
            ),
            const Divider(color:Colors.white10),
            //add images for the questions here
            Image.asset(coloredImages[index]),
            const SizedBox(height: 25.0),
            for(int i = 0; i < _questions[index].options.length; i++)
              GestureDetector(
                onTap: () => answerChecker(_questions[index].options.values.toList()[i]),
                child: QuestionInput(
                  input: _questions[index].options.keys.toList()[i],
                  
                  color: clicked ? _questions[index].options.values.toList()[i] == true ? 
                  Colors.green : Colors.red : Colors.white,
                  
                ),
              )
              
            
          ],
        ),
      ),



      //next question button
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal:10.0),
        child: nextQuestion(
          futureQuestion: futureQuestion,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, 
      )
      );
  }
}