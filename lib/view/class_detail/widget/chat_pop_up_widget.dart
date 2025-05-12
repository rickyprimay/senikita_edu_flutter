import 'package:flutter/material.dart';
import 'package:widya/view/class_detail/widget/chat_screen.dart';

void showChatPopUp(
  BuildContext context,
  String courseName,
  String courseDescription,
  String lessonName,
  String lessonDescription,
  String lessonContent,
) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ChatScreen(
        courseName: courseName,
        courseDescription: courseDescription,
        lessonName: lessonName,
        lessonDescription: lessonDescription,
        lessonContent: lessonContent,
      ),
    ),
  );
}