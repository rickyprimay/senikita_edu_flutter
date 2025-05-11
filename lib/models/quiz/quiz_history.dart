import 'package:widya/models/quiz/quiz_question.dart';

class QuizHistory {
  final QuizQuestion question;
  final dynamic userAnswer; // Can be null or an answer object
  
  QuizHistory({
    required this.question,
    this.userAnswer,
  });
  
  factory QuizHistory.fromJson(Map<String, dynamic> json) {
    return QuizHistory(
      question: QuizQuestion.fromJson(json['question']),
      userAnswer: json['user_answer'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'question': question.toJson(),
      'user_answer': userAnswer,
    };
  }
}