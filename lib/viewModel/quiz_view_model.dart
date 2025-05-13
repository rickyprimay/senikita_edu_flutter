import 'package:flutter/material.dart';
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

  // Updated properties to match new model
  Quiz? _quiz;
  Quiz? get quiz => _quiz;
  
  // For backward compatibility, provide a quizzes getter
  List<QuizClass> get quizzes => _quiz?.data.quiz != null ? [_quiz!.data.quiz] : [];
  
  // Expose the new data structure components
  QuizClass? get currentQuiz => _quiz?.data.quiz;
  List<History>? get quizHistory => _quiz?.data.history;
  Attempt? get latestAttempt => _quiz?.data.latestAttempt;
  
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
      
      _quiz = Quiz.fromJson(response);
      
      if (!(_quiz?.success ?? false) || _quiz?.data.quiz == null) {
        _error = _quiz?.message ?? "Failed to load quiz";
      }
    } catch (e) {
      _error = e.toString();
      _quiz = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchQuizHistory(int lessonId) async {
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
      
      _quiz = Quiz.fromJson(response);
      
      if (!(_quiz?.success ?? false) || _quiz?.data.quiz == null) {
        _error = _quiz?.message ?? "Failed to load quiz history";
      }
    } catch (e) {
      _error = e.toString();
      _quiz = null;
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

      final response = await _quizRepository.submitQuiz(
        lessonId: lessonId, 
        token: token,
        body: body,
        context: context
      );
      
      _submissionResult = response;
      
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}