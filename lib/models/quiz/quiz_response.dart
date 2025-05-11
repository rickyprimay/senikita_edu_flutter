import 'package:widya/models/quiz/quiz.dart';

class QuizResponse {
  final List<Quiz> data;

  QuizResponse({required this.data});

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    List<Quiz> quizList = [];
    
    if (json['data'] != null) {
      if (json['data'] is List) {
        quizList = (json['data'] as List)
            .map((quizJson) => Quiz.fromJson(quizJson))
            .toList();
      } else if (json['data'] is Map) {
        quizList = [Quiz.fromJson(json['data'])];
      }
    }
    
    return QuizResponse(data: quizList);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((quiz) => quiz.toJson()).toList(),
    };
  }
}