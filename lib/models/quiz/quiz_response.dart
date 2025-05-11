class Quiz {
    bool success;
    String message;
    Data data;

    Quiz({
        required this.success,
        required this.message,
        required this.data,
    });

    factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: Data.fromJson(json["data"] ?? {}),
    );
}

class Data {
    QuizClass quiz;
    List<History> history;
    Attempt latestAttempt;

    Data({
        required this.quiz,
        required this.history,
        required this.latestAttempt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        quiz: QuizClass.fromJson(json["quiz"] ?? {}),
        history: List<History>.from((json["history"] ?? []).map((x) => History.fromJson(x))),
        latestAttempt: Attempt.fromJson(json["latest_attempt"] ?? {}),
    );
}

class History {
    Question question;
    UserAnswer userAnswer;

    History({
        required this.question,
        required this.userAnswer,
    });

    factory History.fromJson(Map<String, dynamic> json) => History(
        question: Question.fromJson(json["question"] ?? {}),
        userAnswer: UserAnswer.fromJson(json["user_answer"] ?? {}),
    );
}

class Question {
    int id;
    int quizId;
    String question;
    String type;
    int points;
    DateTime createdAt;
    DateTime updatedAt;
    List<SelectedAnswerElement>? answers;

    Question({
        required this.id,
        required this.quizId,
        required this.question,
        required this.type,
        required this.points,
        required this.createdAt,
        required this.updatedAt,
        this.answers,
    });

    factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"] ?? 0,
        quizId: json["quiz_id"] ?? 0,
        question: json["question"] ?? "",
        type: json["type"] ?? "",
        points: json["points"] ?? 0,
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
        answers: json["answers"] != null 
            ? List<SelectedAnswerElement>.from(
                json["answers"].map((x) => SelectedAnswerElement.fromJson(x))
              ) 
            : null,
    );
}

class SelectedAnswerElement {
    int id;
    int quizQuestionId;
    String answer;
    bool isCorrect;
    DateTime createdAt;
    DateTime updatedAt;

    SelectedAnswerElement({
        required this.id,
        required this.quizQuestionId,
        required this.answer,
        required this.isCorrect,
        required this.createdAt,
        required this.updatedAt,
    });

    factory SelectedAnswerElement.fromJson(Map<String, dynamic> json) => SelectedAnswerElement(
        id: json["id"] ?? 0,
        quizQuestionId: json["quiz_question_id"] ?? 0,
        answer: json["answer"] ?? "",
        isCorrect: json["is_correct"] ?? false,
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
    );
}

class UserAnswer {
    SelectedAnswerElement selectedAnswer;
    bool isCorrect;

    UserAnswer({
        required this.selectedAnswer,
        required this.isCorrect,
    });

    factory UserAnswer.fromJson(Map<String, dynamic> json) => UserAnswer(
        selectedAnswer: SelectedAnswerElement.fromJson(json["selected_answer"] ?? {}),
        isCorrect: json["is_correct"] ?? false,
    );
}

class Attempt {
    int id;
    int userId;
    int quizId;
    int score;
    bool isPassed;
    DateTime startedAt;
    DateTime completedAt;
    DateTime createdAt;
    DateTime updatedAt;
    List<LatestAttemptAnswer>? answers;

    Attempt({
        required this.id,
        required this.userId,
        required this.quizId,
        required this.score,
        required this.isPassed,
        required this.startedAt,
        required this.completedAt,
        required this.createdAt,
        required this.updatedAt,
        this.answers,
    });

    factory Attempt.fromJson(Map<String, dynamic> json) => Attempt(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        quizId: json["quiz_id"] ?? 0,
        score: json["score"] ?? 0,
        isPassed: json["is_passed"] ?? false,
        startedAt: DateTime.parse(json["started_at"] ?? DateTime.now().toIso8601String()),
        completedAt: DateTime.parse(json["completed_at"] ?? DateTime.now().toIso8601String()),
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
        answers: json["answers"] != null 
            ? List<LatestAttemptAnswer>.from(
                json["answers"].map((x) => LatestAttemptAnswer.fromJson(x))
              ) 
            : null,
    );
}

class LatestAttemptAnswer {
    int id;
    int userQuizAttemptId;
    int quizQuestionId;
    int quizAnswerId;
    bool isCorrect;
    DateTime createdAt;
    DateTime updatedAt;
    Question question;
    SelectedAnswerElement answer;

    LatestAttemptAnswer({
        required this.id,
        required this.userQuizAttemptId,
        required this.quizQuestionId,
        required this.quizAnswerId,
        required this.isCorrect,
        required this.createdAt,
        required this.updatedAt,
        required this.question,
        required this.answer,
    });

    factory LatestAttemptAnswer.fromJson(Map<String, dynamic> json) => LatestAttemptAnswer(
        id: json["id"] ?? 0,
        userQuizAttemptId: json["user_quiz_attempt_id"] ?? 0,
        quizQuestionId: json["quiz_question_id"] ?? 0,
        quizAnswerId: json["quiz_answer_id"] ?? 0,
        isCorrect: json["is_correct"] ?? false,
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
        question: Question.fromJson(json["question"] ?? {}),
        answer: SelectedAnswerElement.fromJson(json["answer"] ?? {}),
    );
}

class QuizClass {
    int id;
    int lessonId;
    String title;
    String description;
    int passingScore;
    bool isActive;
    DateTime createdAt;
    DateTime updatedAt;
    List<Question> questions;
    List<Attempt> attempts;

    QuizClass({
        required this.id,
        required this.lessonId,
        required this.title,
        required this.description,
        required this.passingScore,
        required this.isActive,
        required this.createdAt,
        required this.updatedAt,
        required this.questions,
        required this.attempts,
    });

    factory QuizClass.fromJson(Map<String, dynamic> json) => QuizClass(
        id: json["id"] ?? 0,
        lessonId: json["lesson_id"] ?? 0,
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        passingScore: json["passing_score"] ?? 0,
        isActive: json["is_active"] ?? false,
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
        questions: List<Question>.from(
            (json["questions"] ?? []).map((x) => Question.fromJson(x))
        ),
        attempts: List<Attempt>.from(
            (json["attempts"] ?? []).map((x) => Attempt.fromJson(x))
        ),
    );
}