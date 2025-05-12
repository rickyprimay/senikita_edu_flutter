import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/models/quiz/quiz_response.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/viewModel/quiz_view_model.dart';

class HistoryQuizScreen extends StatefulWidget {
  final int? lessonId;
  const HistoryQuizScreen({super.key, this.lessonId});

  @override
  State<HistoryQuizScreen> createState() => _HistoryQuizScreenState();
}

class _HistoryQuizScreenState extends State<HistoryQuizScreen> {
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadQuizHistory();
  }
  
  Future<void> _loadQuizHistory() async {
    setState(() {
      _isLoading = true;
    });
    
    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    
    if (widget.lessonId != null) {
      await quizViewModel.fetchQuizHistory(widget.lessonId!);
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Riwayat Quiz",
          style: AppFont.crimsonTextSubtitle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.tertiary,
              ],
            ),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tertiary.withAlpha(120),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: Loading(opacity: 0.5))
          : Consumer<QuizViewModel>(
              builder: (context, quizViewModel, _) {
                if (quizViewModel.error != null) {
                  return Center(
                    child: Text(
                      "Error: ${quizViewModel.error}",
                      style: AppFont.ralewaySubtitle,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final quizHistory = quizViewModel.quizHistory;
                final attempts = quizViewModel.latestAttempt != null 
                    ? [quizViewModel.latestAttempt!]
                    : [];
                
                if ((quizHistory == null || quizHistory.isEmpty) && attempts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_edu,
                          size: 64,
                          color: AppColors.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Belum ada riwayat quiz",
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLatestAttemptSummary(quizViewModel),
                      const SizedBox(height: 24),
                      _buildHistoryList(quizViewModel),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildLatestAttemptSummary(QuizViewModel quizViewModel) {
    final latestAttempt = quizViewModel.latestAttempt;
    
    if (latestAttempt == null) {
      return const SizedBox.shrink();
    }

    final int totalQuestions = quizViewModel.currentQuiz?.questions.length ?? 1;
    final int percentageScore = totalQuestions > 0 
        ? ((latestAttempt.score / totalQuestions) * 100).round()
        : latestAttempt.score;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: latestAttempt.isPassed 
                  ? AppColors.customGreen.withOpacity(0.12)
                  : AppColors.customRed.withOpacity(0.12),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hasil Quiz Terbaru",
                  style: AppFont.crimsonTextHeader.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      latestAttempt.isPassed ? Icons.check_circle : Icons.cancel,
                      color: latestAttempt.isPassed ? AppColors.customGreen : AppColors.customRed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      latestAttempt.isPassed ? "Lulus" : "Belum Lulus",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: latestAttempt.isPassed ? AppColors.customGreen : AppColors.customRed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(
                  "Tanggal Pengerjaan",
                  _formatDate(latestAttempt.completedAt),
                  Icons.calendar_today,
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  "Nilai",
                  "$percentageScore",
                  Icons.score,
                ),
                const SizedBox(height: 12),
                _buildProgressIndicator(percentageScore),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(int score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 8,
              width: MediaQuery.of(context).size.width * (score / 100) * 0.85,
              decoration: BoxDecoration(
                color: score >= 70 ? AppColors.customGreen : AppColors.customRed,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoryList(QuizViewModel quizViewModel) {
    final quizHistory = quizViewModel.quizHistory;
    
    if (quizHistory == null || quizHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Detail Jawaban",
          style: AppFont.crimsonTextHeader.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: quizHistory.length,
          itemBuilder: (context, index) {
            final historyItem = quizHistory[index];
            return _buildQuestionAnswerCard(historyItem, index);
          },
        ),
      ],
    );
  }

  Widget _buildQuestionAnswerCard(History historyItem, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: historyItem.userAnswer.isCorrect 
                  ? AppColors.customGreen.withOpacity(0.12) 
                  : AppColors.customRed.withOpacity(0.12),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "${index + 1}",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    historyItem.question.question,
                    style: AppFont.ralewaySubtitle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  historyItem.userAnswer.isCorrect 
                      ? Icons.check_circle 
                      : Icons.cancel,
                  color: historyItem.userAnswer.isCorrect 
                      ? AppColors.customGreen
                      : AppColors.customRed,
                  size: 24,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jawaban Anda:",
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: historyItem.userAnswer.isCorrect
                        ? AppColors.customGreen.withOpacity(0.08)
                        : AppColors.customRed.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: historyItem.userAnswer.isCorrect
                          ? AppColors.customGreen.withOpacity(0.35)
                          : AppColors.customRed.withOpacity(0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        historyItem.userAnswer.isCorrect
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        color: historyItem.userAnswer.isCorrect
                            ? AppColors.customGreen
                            : AppColors.customRed,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          historyItem.userAnswer.selectedAnswer.answer,
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!historyItem.userAnswer.isCorrect) ...[
                  const SizedBox(height: 16),
                  Text(
                    "Jawaban Benar:",
                    style: AppFont.ralewaySubtitle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCorrectAnswerContainer(historyItem),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectAnswerContainer(History historyItem) {
    // Find the correct answer
    final correctAnswer = historyItem.question.answers?.firstWhere(
      (answer) => answer.isCorrect,
      orElse: () => SelectedAnswerElement(
        id: 0,
        quizQuestionId: 0,
        answer: "Tidak ditemukan",
        isCorrect: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.customGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.customGreen.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.customGreen,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              correctAnswer?.answer ?? "",
              style: AppFont.ralewaySubtitle.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          "$label: ",
          style: AppFont.ralewaySubtitle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppFont.ralewaySubtitle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}