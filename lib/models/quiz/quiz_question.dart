import 'package:widya/models/quiz/answert.dart';

class QuizQuestion {
  final int? id;
  final int? quizId;
  final String? question;
  final String? type;
  final int? points;
  final String? createdAt;
  final String? updatedAt;
  final List<Answer>? answers;

  QuizQuestion({
    this.id,
    this.quizId,
    this.question,
    this.type,
    this.points,
    this.createdAt,
    this.updatedAt,
    this.answers,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    var answersList = <Answer>[];
    if (json['answers'] != null) {
      answersList = (json['answers'] as List)
          .map((answerJson) => Answer.fromJson(answerJson))
          .toList();
    }

    return QuizQuestion(
      id: json['id'],
      quizId: json['quiz_id'],
      question: json['question'],
      type: json['type'],
      points: json['points'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      answers: answersList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'question': question,
      'type': type,
      'points': points,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'answers': answers?.map((answer) => answer.toJson()).toList(),
    };
  }
}