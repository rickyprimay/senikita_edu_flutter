import 'package:flutter/material.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/utils/utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
        final isLectureCompleted = completedLectures.contains(index) || (lesson.isCompleted ?? false);
        
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompletionIndicator(context, index, isSelected, isLectureCompleted),
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
    bool isCompleted
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: isCompleted
        ? const Icon(Icons.check_circle, color: AppColors.primary)
        : IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.circle_outlined,
              color: AppColors.primary,
            ),
            onPressed: () {
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
          ),
    );
  }
  
  void _showCompletionConfirmation(BuildContext context, int index) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      widget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Apakah kamu yakin ingin menyeslesaikan sesi ini?',
              style: AppFont.crimsonTextSubtitle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Jika kamu menyelesaikan sesi ini, kamu bisa mengakses lagi namun tidak bisa membatalkan status selesainya.',
              style: AppFont.crimsonTextSubtitle.copyWith(
                fontSize: 14,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
      confirmBtnText: 'Yakin',
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        onMarkComplete(index);
        Utils.showToastification("Berhasil", "Sesi berhasil diselesaikan", true, context);
      },
      confirmBtnColor: AppColors.primary,
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
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.brown[700],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Saat Ini',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
      ],
    );
  }
  
  Widget _buildLessonMetadata(Lesson lesson) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text(
          '${lesson.duration ?? 10} menit',
          style: TextStyle(fontSize: 12, color: Colors.grey[800]),
        ),
        const SizedBox(width: 6),
        Icon(lesson.videoUrl != null ? Icons.videocam : Icons.menu_book_sharp, size: 16, color: Colors.grey[700]),
      ],
    );
  }
}