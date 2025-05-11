import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/models/quiz/quiz.dart';
import 'package:widya/models/quiz/quiz_question.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/viewModel/quiz_view_model.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  final String quizTitle;
  final int timeLimit; 
  final int lessonId;

  const QuizScreen({
    super.key, 
    required this.quizTitle,
    required this.timeLimit,
    required this.lessonId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  late Timer _timer;
  int _timeRemaining = 0; 
  Map<int, int> _userAnswers = {}; 
  bool _isLoading = true;
  List<LocalQuizQuestion> _questions = [];

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.timeLimit * 60;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchQuizData();
    });
  }

  Future<void> _fetchQuizData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
      await quizViewModel.fetchQuiz(widget.lessonId);
      
      if (quizViewModel.error != null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }
      
      if (quizViewModel.quizzes.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }
      
      final questions = _convertApiToLocalQuestions(quizViewModel.quizzes.first);
      
      if (mounted) {
        setState(() {
          _questions = questions;
          _isLoading = false;
        });
        
        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
      
      return LocalQuizQuestion(
        question: question.question ?? "No Question",
        options: options,
        correctAnswerIndex: correctIndex,
      );
    }).toList();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _finishQuiz();
      }
    });
  }

  void _finishQuiz() {
    _timer.cancel();
    _showResult();
  }

  void _showResult() {
    if (_questions.isEmpty) return;
    
    int correctAnswers = 0;
    _userAnswers.forEach((questionIndex, answerIndex) {
      if (answerIndex == _questions[questionIndex].correctAnswerIndex) {
        correctAnswers++;
      }
    });

    final score = (correctAnswers / _questions.length) * 100;
    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    final passingScore = quizViewModel.quizzes.isNotEmpty ? 
        quizViewModel.quizzes.first.passingScore ?? 70 : 70;
    
    final isPassed = score >= passingScore;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          children: [
            Column(
              children: [
                Text(
                  isPassed ? "Selamat! 🎉" : "Coba Lagi 😕",
                  textAlign: TextAlign.center,
                  style: AppFont.crimsonTextHeader.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isPassed ? AppColors.primary : AppColors.customRed,
                  ),
                ),

                const SizedBox(height: 24),
                
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPassed ? AppColors.customGreen.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    border: Border.all(
                      color: isPassed ? AppColors.customGreen : Colors.redAccent,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${score.toInt()}%",
                      style: AppFont.crimsonTextHeader.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isPassed ? AppColors.customGreen : Colors.redAccent,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Jawaban benar: $correctAnswers dari ${_questions.length} soal",
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  isPassed 
                      ? "Kamu telah menyelesaikan quiz ini dengan baik!" 
                      : "Kamu belum mencapai nilai minimum untuk lulus.",
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          side: BorderSide(color: AppColors.secondary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Kembali ke Materi",
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    if (!isPassed) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            setState(() {
                              _currentIndex = 0;
                              _userAnswers = {};
                              _timeRemaining = widget.timeLimit * 60;
                            });
                            _startTimer();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Coba Lagi",
                            style: AppFont.ralewaySubtitle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],

                    if (isPassed) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Selesai",
                            style: AppFont.ralewaySubtitle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _userAnswers[_currentIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _finishQuiz();
    }
  }

  void _prevQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return SimpleDialog(
                  backgroundColor: Colors.white,
                  contentPadding: const EdgeInsets.all(30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  children: [
                    Column(
                      children: [
                        Text(
                          'Keluar dari Quiz?', 
                          style: AppFont.crimsonTextSubtitle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary, 
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Progres quiz tidak akan tersimpan jika kamu keluar sekarang.',
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 14,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w500
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: BorderSide(color: AppColors.primary),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Lanjutkan Quiz',
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.customRed,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Keluar',
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
        title: Text(
          widget.quizTitle,
          style: AppFont.crimsonTextSubtitle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  _formatTime(_timeRemaining),
                  style: AppFont.ralewaySubtitle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<QuizViewModel>(
        builder: (context, quizViewModel, child) {
          if (_isLoading) {
            return const Center(child: Loading(opacity: 1.0));
          }
          
          if (quizViewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.customRed),
                  const SizedBox(height: 16),
                  Text(
                    "Gagal memuat quiz",
                    style: AppFont.crimsonTextHeader.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      quizViewModel.error!,
                      style: AppFont.ralewaySubtitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Kembali"),
                  ),
                ],
              ),
            );
          }
          
          if (_questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    "Quiz tidak tersedia",
                    style: AppFont.crimsonTextHeader.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      "Tidak ada pertanyaan yang tersedia untuk quiz ini",
                      style: AppFont.ralewaySubtitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Kembali"),
                  ),
                ],
              ),
            );
          }
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (_currentIndex + 1) / _questions.length,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.tertiary,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Soal ${_currentIndex + 1}/${_questions.length}",
                        style: AppFont.ralewaySubtitle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${_userAnswers.length}/${_questions.length} terjawab",
                            style: AppFont.ralewaySubtitle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _questions[_currentIndex].question,
                              style: AppFont.ralewaySubtitle.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ...List.generate(_questions[_currentIndex].options.length, (index) {
                              final isSelected = _userAnswers[_currentIndex] == index;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: InkWell(
                                  onTap: () => _selectAnswer(index),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected 
                                            ? AppColors.primary
                                            : Colors.grey.withOpacity(0.3),
                                        width: isSelected ? 2 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      color: isSelected 
                                          ? AppColors.primary.withOpacity(0.1)
                                          : Colors.transparent,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? AppColors.primary
                                                : Colors.grey.withOpacity(0.2),
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : Colors.grey.withOpacity(0.5),
                                            ),
                                          ),
                                          child: Center(
                                            child: isSelected
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 16,
                                                  )
                                                : Text(
                                                    String.fromCharCode(65 + index),
                                                    style: AppFont.crimsonTextSubtitle.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            _questions[_currentIndex].options[index],
                                            style: AppFont.ralewaySubtitle.copyWith(
                                              fontSize: 16,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                              color: isSelected ? AppColors.primary : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (_currentIndex > 0)
                      OutlinedButton.icon(
                        onPressed: _prevQuestion,
                        icon: const Icon(Icons.arrow_back, size: 16),
                        label: const Text("Sebelumnya"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _currentIndex == _questions.length - 1
                          ? () => _finishQuiz()
                          : _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentIndex == _questions.length - 1 ? "Selesai" : "Selanjutnya",
                            style: AppFont.ralewaySubtitle.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          if (_currentIndex < _questions.length - 1)
                            const Icon(Icons.arrow_forward, size: 16)
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class LocalQuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  LocalQuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}