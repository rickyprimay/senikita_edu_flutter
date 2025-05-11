import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/provider/quiz_provider.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';

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
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      quizProvider.initializeQuiz(widget.lessonId, widget.timeLimit);
    });
  }

  void _showExitDialog() {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.pauseTimer();
    
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
                          quizProvider.resumeTimer();
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
  }

  void _showResult() {
  final quizProvider = Provider.of<QuizProvider>(context, listen: false);
  final score = quizProvider.calculateScore();
  final correctAnswers = quizProvider.getCorrectAnswersCount();
  final isPassed = quizProvider.isPassed();
  
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
                      "$score%",
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
                  "Jawaban benar: $correctAnswers dari ${quizProvider.questions.length} soal",
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
                    if (!isPassed) ...[
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            quizProvider.resetQuiz(widget.timeLimit);
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
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            Navigator.of(context).pop({'isPassed': true});
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
                            "Kembali ke Kelas",
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

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        return 
        Stack(
          children: [ 
            Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: _showExitDialog,
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
                        quizProvider.formatTime(quizProvider.timeRemaining),
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
            body: quizProvider.isLoading
                ? const Center(child: Loading(opacity: 1.0))
                : quizProvider.error != null
                    ? _buildErrorView(quizProvider.error!)
                    : quizProvider.isQuizEmpty
                        ? _buildEmptyQuizView()
                        : _buildQuizContent(quizProvider),
          ),
          if (quizProvider.isLoading && quizProvider.questions.isNotEmpty) const Loading(opacity: 0.7),
          ]
        );
      },
    );
  }

  Widget _buildErrorView(String errorMessage) {
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
              errorMessage,
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

  Widget _buildEmptyQuizView() {
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

  Widget _buildQuizContent(QuizProvider quizProvider) {
    final currentQuestion = quizProvider.questions[quizProvider.currentIndex];
    
    return 
    Stack(
      children: [
       Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar
            Container(
              width: double.infinity,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (quizProvider.currentIndex + 1) / quizProvider.questions.length,
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
            
            // Question counter
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Soal ${quizProvider.currentIndex + 1}/${quizProvider.questions.length}",
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
                        "${quizProvider.completedQuestions}/${quizProvider.questions.length} terjawab",
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
                          currentQuestion.question,
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...List.generate(currentQuestion.options.length, (index) {
                          final isSelected = quizProvider.userAnswers[quizProvider.currentIndex] == index;
                          return _buildOptionItem(quizProvider, index, isSelected, currentQuestion.options[index]);
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
                if (quizProvider.currentIndex > 0)
                  OutlinedButton.icon(
                    onPressed: quizProvider.prevQuestion,
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
                  onPressed: quizProvider.currentIndex == quizProvider.questions.length - 1
                  ? () async {
                      quizProvider.finishQuiz();
      
                      final success = await quizProvider.submitUserAnswers(widget.lessonId, context);
      
                      _showResult();
      
                      if (!success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal mengirim jawaban ke server, namun skor telah dihitung.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    }
                  : quizProvider.nextQuestion,
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
                        quizProvider.currentIndex == quizProvider.questions.length - 1 ? "Selesai" : "Selanjutnya",
                        style: AppFont.ralewaySubtitle.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      if (quizProvider.currentIndex < quizProvider.questions.length - 1)
                        const Icon(Icons.arrow_forward, size: 16)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ],
    );
  }

  Widget _buildOptionItem(QuizProvider quizProvider, int index, bool isSelected, String optionText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => quizProvider.selectAnswer(index),
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
                  optionText,
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
  }
}