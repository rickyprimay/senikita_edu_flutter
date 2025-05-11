import 'dart:async';
import 'package:flutter/material.dart';
import 'package:widya/models/quiz/quiz.dart';
import 'package:widya/viewModel/quiz_view_model.dart';

class LocalQuizQuestion {
  final int id; 
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final List<LocalQuizAnswer> answers;  

  LocalQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.answers,
  });
}
class LocalQuizAnswer {
  final int id;
  final String answer;
  final bool isCorrect;

  LocalQuizAnswer({
    required this.id,
    required this.answer,
    required this.isCorrect,
  });
}

class QuizProvider extends ChangeNotifier {
  final QuizViewModel quizViewModel;
  
  // State variables
  int _currentIndex = 0;
  Timer? _timer;
  int _timeRemaining = 0;
  Map<int, int> _userAnswers = {};
  bool _isLoading = false;
  List<LocalQuizQuestion> _questions = [];
  bool _isPaused = false;
  
  // Getters
  int get currentIndex => _currentIndex;
  int get timeRemaining => _timeRemaining;
  Map<int, int> get userAnswers => _userAnswers;
  bool get isLoading => _isLoading || quizViewModel.loading;
  List<LocalQuizQuestion> get questions => _questions;
  String? get error => quizViewModel.error;
  bool get isQuizEmpty => _questions.isEmpty;
  int get completedQuestions => _userAnswers.length;
  bool get isPaused => _isPaused;
  
  QuizProvider({required this.quizViewModel});

  Future<void> initializeQuiz(int lessonId, int timeLimit) async {
    _currentIndex = 0;
    _userAnswers = {};
    _timeRemaining = timeLimit * 60;
    _isLoading = true;
    notifyListeners();
    
    await fetchQuizData(lessonId);
    
    if (_questions.isNotEmpty && !_isPaused) {
      startTimer();
    }
  }
  
  Future<void> fetchQuizData(int lessonId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await quizViewModel.fetchQuiz(lessonId);
      
      if (quizViewModel.quizzes.isNotEmpty) {
        _questions = _convertApiToLocalQuestions(quizViewModel.quizzes.first);
      }
    } catch (e) {
      // ViewModel already handles errors
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void startTimer() {
    _isPaused = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0 && !_isPaused) {
        _timeRemaining--;
        notifyListeners();
      } else if (_timeRemaining <= 0) {
        finishQuiz();
      }
    });
  }
  
  void pauseTimer() {
    _isPaused = true;
    notifyListeners();
  }
  
  void resumeTimer() {
    _isPaused = false;
    notifyListeners();
  }
  
  void selectAnswer(int answerIndex) {
    _userAnswers[_currentIndex] = answerIndex;
    notifyListeners();
  }
  
  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    } else {
      finishQuiz();
    }
  }
  
  void prevQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }
  
  void finishQuiz() {
    _timer?.cancel();
  }
  
  int calculateScore() {
    if (_questions.isEmpty) return 0;
    
    int correctAnswers = 0;
    _userAnswers.forEach((questionIndex, answerIndex) {
      if (answerIndex == _questions[questionIndex].correctAnswerIndex) {
        correctAnswers++;
      }
    });
    
    return (correctAnswers / _questions.length * 100).toInt();
  }
  
  int getPassingScore() {
    return quizViewModel.quizzes.isNotEmpty ? 
        quizViewModel.quizzes.first.passingScore ?? 70 : 70;
  }
  
  int getCorrectAnswersCount() {
    if (_questions.isEmpty) return 0;
    
    int correctAnswers = 0;
    _userAnswers.forEach((questionIndex, answerIndex) {
      if (answerIndex == _questions[questionIndex].correctAnswerIndex) {
        correctAnswers++;
      }
    });
    
    return correctAnswers;
  }
  
  bool isPassed() {
    return calculateScore() >= getPassingScore();
  }
  
  void resetQuiz(int timeLimit) {
    _currentIndex = 0;
    _userAnswers = {};
    _timeRemaining = timeLimit * 60;
    notifyListeners();
    startTimer();
  }
  
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  List<LocalQuizQuestion> _convertApiToLocalQuestions(Quiz quiz) {
    if (quiz.questions == null) return [];

    return quiz.questions!.map((question) {
      final options = question.answers?.map((a) => a.answer ?? "").toList() ?? [];

      int correctIndex = 0;
      if (question.answers != null) {
        for (int i = 0; i < question.answers!.length; i++) {
          if (question.answers![i].isCorrect == true) {
            correctIndex = i;
            break;
          }
        }
      }

      final localAnswers = question.answers?.map((a) => LocalQuizAnswer(
        id: a.id ?? 0,
        answer: a.answer ?? "",
        isCorrect: a.isCorrect ?? false,
      )).toList() ?? [];

      return LocalQuizQuestion(
        id: question.id ?? 0,
        question: question.question ?? "No Question",
        options: options,
        correctAnswerIndex: correctIndex,
        answers: localAnswers,
      );
    }).toList();
  }

  Future<bool> submitUserAnswers(int lessonId, BuildContext context) async {
    Map<int, int> formattedAnswers = {};

    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers.containsKey(i)) {
        int questionId = _questions[i].id;

        int answerId = _questions[i].answers[_userAnswers[i]!].id;

        formattedAnswers[questionId] = answerId;
      }
    }

    return await quizViewModel.submitQuiz(lessonId, formattedAnswers, context);
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}