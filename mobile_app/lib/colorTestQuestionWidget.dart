import 'package:flutter/material.dart';


class colorTestQuestionWidget extends StatelessWidget {
  const colorTestQuestionWidget({Key? key, required this.question, required this.indexAction, required this.totalQuestions}) : super(key: key);


  final String question;
  final int indexAction;
  final int totalQuestions;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text('Question ${indexAction + 1}/$totalQuestions: $question')
    );
  }
}