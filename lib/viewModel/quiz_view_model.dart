import 'package:flutter/material.dart';
import 'package:widya/models/quiz/quiz.dart';
import 'package:widya/models/quiz/quiz_response.dart';
import 'package:widya/repository/quiz_repository.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:widya/res/widgets/shared_preferences.dart';

class QuizViewModel extends ChangeNotifier {
  final QuizRepository _quizRepository = QuizRepository();

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  List<Quiz> _quizzes = [];
  List<Quiz> get quizzes => _quizzes;

  // Add this map to store submission result
  Map<String, dynamic>? _submissionResult;
  Map<String, dynamic>? get submissionResult => _submissionResult;

  Future<void> fetchQuiz(int lessonId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");

    if (token == null) {
      _error = "Token tidak ditemukan. Silakan login ulang.";
      _loading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await _quizRepository.fetchQUiz(lessonId: lessonId, token: token);
      AppLogger.logInfo("response: $response");
      final quizResponse = QuizResponse.fromJson(response);
      _quizzes = quizResponse.data;
      AppLogger.logInfo("quizzes: $_quizzes");
    } catch (e) {
      AppLogger.logError("Error fetching quizzes: $e");
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  Future<bool> submitQuiz(int lessonId, Map<int, int> answers, BuildContext context) async {
    _loading = true;
    _error = null;
    _submissionResult = null;
    notifyListeners();

    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");

    if (token == null) {
      _error = "Token tidak ditemukan. Silakan login ulang.";
      _loading = false;
      notifyListeners();
      return false;
    }

    try {
      final List<Map<String, dynamic>> formattedAnswers = [];
      
      answers.forEach((questionId, answerId) {
        formattedAnswers.add({
          "question_id": questionId,
          "quiz_answer_id": answerId
        });
      });

      final Map<String, dynamic> body = {
        "answers": formattedAnswers
      };

      AppLogger.logInfo("Submitting quiz answers: $body");
      
      final response = await _quizRepository.submitQuiz(
        lessonId: lessonId, 
        token: token,
        body: body,
        context: context
      );
      
      AppLogger.logInfo("Quiz submission response: $response");
      _submissionResult = response;
      
      return true;
    } catch (e) {
      AppLogger.logError("Error submitting quiz: $e");
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}