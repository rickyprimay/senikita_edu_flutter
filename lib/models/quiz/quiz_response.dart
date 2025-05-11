import 'package:widya/models/quiz/quiz.dart';

class QuizResponse {
  List<Quiz> data;

  QuizResponse({required this.data});

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      data: List<Quiz>.from(json['data'].map((quiz) => quiz.fromJson(quiz))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((quiz) => quiz.toJson()).toList(),
    };
  }
}
