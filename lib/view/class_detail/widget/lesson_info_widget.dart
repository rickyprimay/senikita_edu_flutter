import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:widya/models/lessons/additionals_materials.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

class LessonInfoWidget extends StatelessWidget {
  final Lesson lesson;
  final List<AdditionalMaterial>? additionalMaterial;
  final _flutterMediaDownloaderPlugin = MediaDownload();
  
  LessonInfoWidget({
    Key? key,
    required this.lesson,
    required this.additionalMaterial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (additionalMaterial == null || additionalMaterial!.isEmpty) ...[
              Text(
                lesson.title ?? '',
                style: AppFont.crimsonTextHeader.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
            if (additionalMaterial != null && additionalMaterial!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Materi Tambahan",
                      style: AppFont.crimsonTextHeader.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Dokumen dan referensi pendukung untuk kursus ini",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...additionalMaterial!.map((material) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: Colors.grey[700],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                material.titleWithExtension,
                                style: AppFont.ralewaySubtitle.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () async {
                                _flutterMediaDownloaderPlugin.downloadMedia(context, material.filePath);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: Text(
                                "Unduh",
                                style: AppFont.ralewaySubtitle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            (lesson.type == 'lesson' || lesson.type == 'quiz')
            ? Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Durasi ${lesson.duration ?? '30'} Menit',
                    style: AppFont.nunitoSubtitle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              )
            : const SizedBox(),
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
            (lesson.type == 'lesson' || lesson.type == 'quiz')
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Isi Konten :',
                    style: AppFont.ralewaySubtitle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Html(
                    data: lesson.description,
                    style: {
                      "body": Style(
                        fontSize: FontSize(12),
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary,
                        textAlign: TextAlign.justify,
                        fontFamily: AppFont.ralewaySubtitle.fontFamily,
                      ),
                    },
                  )
                ],
              )
            : const SizedBox(),
          ],
        ),
      ),
    );
  }
}