


import 'package:widya/models/quiz/quiz_question.dart';

class Quiz {
  final int? id;
  final int? lessonId;
  final String? title;
  final String? description;
  final int? passingScore;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final List<QuizQuestion>? questions;

  Quiz({
    this.id,
    this.lessonId,
    this.title,
    this.description,
    this.passingScore,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    var questionsList = <QuizQuestion>[];
    if (json['questions'] != null) {
      questionsList = (json['questions'] as List)
          .map((questionJson) => QuizQuestion.fromJson(questionJson))
          .toList();
    }

    return Quiz(
      id: json['id'],
      lessonId: json['lesson_id'],
      title: json['title'],
      description: json['description'],
      passingScore: json['passing_score'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      questions: questionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'title': title,
      'description': description,
      'passing_score': passingScore,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'questions': questions?.map((question) => question.toJson()).toList(),
    };
  }
}