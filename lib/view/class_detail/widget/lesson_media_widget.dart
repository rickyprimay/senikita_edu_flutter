import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/utils/routes/routes_names.dart';
import 'package:widya/view/class_detail/widget/youtube_player_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonMediaWidget extends StatelessWidget {
  final Lesson lesson;
  final YoutubePlayerController? youtubeController;
  final String? currentVideoUrl;
  final int selectedIndex;
  final Function(String?) initializeYoutubeController;
  final Function(int) markLessonAsComplete;
  final Function(int) updateSelectedContent;

  const LessonMediaWidget({
    Key? key,
    required this.lesson,
    required this.youtubeController,
    required this.currentVideoUrl,
    required this.selectedIndex,
    required this.initializeYoutubeController,
    required this.markLessonAsComplete,
    required this.updateSelectedContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lesson.type?.toLowerCase() == "lesson" && lesson.videoUrl != null) {
      if (currentVideoUrl != lesson.videoUrl) {
        initializeYoutubeController(lesson.videoUrl);
      }
      if (youtubeController != null) {
        return RepaintBoundary(
          key: ValueKey(currentVideoUrl),
          child: YoutubePlayerWidget(
            controller: youtubeController!,
            isFullscreen: false,
          ),
        );
      }
    } else if (lesson.type?.toLowerCase() == "final") {
      return _buildFinalContent(context, lesson);
    } else {
      final isQuiz = lesson.type?.toLowerCase() == "quiz";
      return _buildQuizOrOtherContent(context, lesson, isQuiz);
    }
    return const SizedBox.shrink();
  }

  Widget _buildFinalContent(BuildContext context, Lesson lesson) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary.withOpacity(0.9), AppColors.tertiary.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.quiz_rounded,
                      size: 60,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Siap untuk melakukan Submission?",
                      style: AppFont.crimsonTextHeader.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Html(
                data: lesson.content ?? '',
                style: {
                  "body": Style(
                    fontSize: FontSize(14),
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    textAlign: TextAlign.start,
                    fontFamily: AppFont.ralewaySubtitle.fontFamily,
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizOrOtherContent(BuildContext context, Lesson lesson, bool isQuiz) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary.withOpacity(0.9), AppColors.tertiary.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.quiz_rounded,
                      size: 60,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isQuiz ? "Siap untuk Mengukur Pemahamanmu?" : "Konten untuk tipe: ${lesson.type}",
                      style: AppFont.crimsonTextHeader.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Jawab pertanyaan berikut untuk menguji pemahaman kamu tentang materi yang telah dipelajari",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildLessonInfoCard(lesson),
              const SizedBox(height: 20),
              if (isQuiz) _buildStartQuizButton(context, lesson),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonInfoCard(Lesson lesson) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment_outlined, color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "${lesson.title}",
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              Icon(Icons.timer_outlined, color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Text(
                "Durasi: ${lesson.duration} Menit",
                style: AppFont.ralewaySubtitle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.equalizer, color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Text(
                "Tingkat Kesulitan: Dasar",
                style: AppFont.ralewaySubtitle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartQuizButton(BuildContext context, Lesson lesson) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: () async {
          final result = await Navigator.of(context, rootNavigator: true).pushNamed(
            RouteNames.quiz,
            arguments: {
              "quizTitle": lesson.title,
              "timeLimit": lesson.duration,
              "lessonId": lesson.id,
            },
          );

          if (result is Map && result['isPassed'] == true) {
            markLessonAsComplete(selectedIndex);

            // Check and advance to next lesson automatically
            updateSelectedContent(selectedIndex + 1);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Mulai Quiz",
              style: AppFont.ralewaySubtitle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}