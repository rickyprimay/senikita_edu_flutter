import 'package:widya/models/quiz/quiz.dart';
import 'package:widya/models/quiz/quiz_history.dart';

class QuizDataWrapper {
  final Quiz? quiz;
  final List<QuizHistory>? history;
  
  QuizDataWrapper({this.quiz, this.history});
  
  factory QuizDataWrapper.fromJson(Map<String, dynamic> json) {
    // Parse quiz data if present
    Quiz? quizData;
    if (json['quiz'] != null) {
      quizData = Quiz.fromJson(json['quiz']);
    }
    
    // Parse history data if present
    List<QuizHistory>? historyData;
    if (json['history'] != null) {
      historyData = (json['history'] as List)
          .map((historyItem) => QuizHistory.fromJson(historyItem))
          .toList();
    }
    
    return QuizDataWrapper(
      quiz: quizData,
      history: historyData,
    );
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (quiz != null) {
      data['quiz'] = quiz!.toJson();
    }
    
    if (history != null) {
      data['history'] = history!.map((item) => item.toJson()).toList();
    }
    
    return data;
  }
}