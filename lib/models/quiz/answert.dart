class Answer {
  final int? id;
  final int? quizQuestionId;
  final String? answer;
  final bool? isCorrect;
  final String? createdAt;
  final String? updatedAt;

  Answer({
    this.id,
    this.quizQuestionId,
    this.answer,
    this.isCorrect,
    this.createdAt,
    this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      quizQuestionId: json['quiz_question_id'],
      answer: json['answer'],
      isCorrect: json['is_correct'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_question_id': quizQuestionId,
      'answer': answer,
      'is_correct': isCorrect,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}