import 'package:flutter/material.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

class LessonInfoWidget extends StatelessWidget {
  final Lesson lesson;
  
  const LessonInfoWidget({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              lesson.title ?? '',
              style: AppFont.crimsonTextSubtitle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  'Durasi ${lesson.duration ?? '30 menit'} Menit',
                  style: AppFont.nunitoSubtitle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              lesson.description ?? 'Pada kesempatan kali ini kita akan belajar pergerakan tangan',
              style: AppFont.ralewaySubtitle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              'Isi Konten : ${lesson.content}',
              style: AppFont.ralewaySubtitle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}