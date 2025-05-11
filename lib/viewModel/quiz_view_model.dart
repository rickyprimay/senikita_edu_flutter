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
      if (_error != null) {
        AppLogger.logError("Error: $_error");
      } else {
        AppLogger.logInfo("Quizzes fetched successfully.");
      }
      _loading = false;
      notifyListeners();
    }
  }
}
