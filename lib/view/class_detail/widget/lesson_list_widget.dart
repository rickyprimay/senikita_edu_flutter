import 'package:flutter/material.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/utils/utils.dart';

class LessonListWidget extends StatelessWidget {
  final List<Lesson> lessons;
  final int selectedIndex;
  final List<int> completedLectures;
  final Function(int) onLessonSelected;
  final Function(int) onMarkComplete;
  
  const LessonListWidget({
    Key? key,
    required this.lessons,
    required this.selectedIndex,
    required this.completedLectures,
    required this.onLessonSelected,
    required this.onMarkComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        final isSelected = selectedIndex == index;
        final isLectureCompleted = completedLectures.contains(index) || (lesson.isCompleted);
        
        return _buildLessonItem(
          context, 
          lesson, 
          index, 
          isSelected, 
          isLectureCompleted
        );
      },
    );
  }
  
  Widget _buildLessonItem(
    BuildContext context, 
    Lesson lesson, 
    int index, 
    bool isSelected, 
    bool isLectureCompleted
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withAlpha(20) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary.withAlpha(70) : Colors.grey.withAlpha(70),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (!isSelected) {
            onLessonSelected(index);
          }
        },
        splashColor: AppColors.primary.withAlpha(30),
        highlightColor: AppColors.primary.withAlpha(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCompletionIndicator(context, index, isSelected, isLectureCompleted, lesson.type ?? ''),
            const SizedBox(width: 12),
            Expanded(
              child: _buildLessonContent(lesson, isSelected),
            ),
            _buildLessonMetadata(lesson),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCompletionIndicator(
    BuildContext context, 
    int index, 
    bool isSelected, 
    bool isCompleted,
    String lessonType
  ) {
    if (isCompleted) {
      return Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        child: const Icon(
          Icons.check_circle, 
          color: AppColors.primary,
          size: 24, 
        ),
      );
    }

    if (lessonType != "lesson") {
      IconData iconData;
      if (lessonType == "quiz") {
        iconData = Icons.quiz_outlined;
      } else if (lessonType == "final") {
        iconData = Icons.assignment_outlined;
      } else {
        iconData = Icons.article_outlined;
      }

      return Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        child: Icon(
          iconData,
          color: AppColors.primary,
          size: 22,
        ),
      );
    }

    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          if (index == selectedIndex) {
            _showCompletionConfirmation(context, index);
          } else {
            Utils.showToastification(
              "Gagal",
              "Selesaikan hanya bisa diakses di sesi yang sedang dipelajari",
              false,
              context,
            );
          }
        },
        child: const Icon(
          Icons.circle_outlined,
          color: AppColors.primary,
          size: 24,
        ),
      ),
    );
  }
  
  void _showCompletionConfirmation(BuildContext context, int index) {
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
                  'Konfirmasi Selesai',
                  textAlign: TextAlign.center,
                  style: AppFont.crimsonTextHeader.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Apakah kamu yakin ingin menyelesaikan sesi ini?',
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Jika kamu menyelesaikan sesi ini, kamu bisa mengakses lagi namun tidak bisa membatalkan status selesainya.',
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
                          "Batal",
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
                          onMarkComplete(index);
                          Utils.showToastification("Berhasil", "Sesi berhasil diselesaikan", true, context);
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
                          "Yakin",
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
  
  Widget _buildLessonContent(Lesson lesson, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                lesson.title ?? '',
                style: AppFont.ralewaySubtitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            if (isSelected)
            Container(
              margin: const EdgeInsets.only(left: 8, right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.9),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_circle_filled_rounded,
                    color: Colors.white,
                    size: 10,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Saat Ini',
                    style: AppFont.ralewaySubtitle.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
      ],
    );
  }
  
  Widget _buildLessonMetadata(Lesson lesson) {
    return
    (lesson.type == "lesson" || lesson.type == "quiz")
    ? Row(
        children: [
          Icon(Icons.access_time, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            '${lesson.duration ?? 10} menit',
            style: TextStyle(fontSize: 12, color: Colors.grey[800]),
          ),
          const SizedBox(width: 6),
          Icon(lesson.type == "lesson" ? Icons.videocam_outlined : Icons.menu_book_sharp, size: 16, color: Colors.grey[700]),
        ],
      )
    : SizedBox(); 
  }
}