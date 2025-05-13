import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/res/helpers/date_formatter.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:widya/utils/routes/routes_names.dart';
import 'package:widya/viewModel/course_view_model.dart';
import 'package:widya/viewModel/enrollments_view_model.dart';
import 'package:widya/viewModel/lesson_view_model.dart';

class CourseScreen extends StatefulWidget {
  final int courseId;
  final String instructorName;
  final String categoryName;
  final bool isEnrolled;

  const CourseScreen({
    super.key,
    required this.courseId,
    required this.instructorName,
    required this.categoryName,
    required this.isEnrolled,
  });

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {

  final _scrollController = ScrollController();
  final _learnSectionKey = GlobalKey();
  
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<CourseViewModel>(context, listen: false);
      Provider.of<EnrollmentsViewModel>(context, listen: false);
      Provider.of<LessonViewModel>(context, listen: false).fetchLessonByCourseId(widget.courseId);
      viewModel.fetchCourseDetail(widget.courseId);
      AppLogger.logInfo("isEnrolled: ${widget.isEnrolled}");
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CourseViewModel>();
    final enrollmentsViewModel = context.watch<EnrollmentsViewModel>(); 
    final lessonViewModel = context.watch<LessonViewModel>();
    final courseDetail = viewModel.courseDetail;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
      appBar: AppBar(
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tertiary.withAlpha(120),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.loading) {
            return Loading(opacity: 0.2);
          }

          if (viewModel.error != null) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }

          if (courseDetail == null) {
            return const Center(child: Text('Course not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          courseDetail.thumbnail.isNotEmpty
                              ? courseDetail.thumbnail
                              : 'https://eduapi.senikita.my.id/storage/defaultpic.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  courseDetail.title,
                  style: AppFont.crimsonTextHeader.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown.shade300),
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.brown.shade50,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.access_time, color: Colors.brown, size: 12),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  courseDetail.duration,
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 9,
                                    color: Colors.brown,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown.shade300),
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.brown.shade50,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.signal_cellular_alt, color: Colors.brown, size: 12),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  "${courseDetail.level[0].toUpperCase()}${courseDetail.level.substring(1)}",
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 9,
                                    color: Colors.brown,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown.shade300),
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.brown.shade50,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people, color: Colors.brown, size: 12),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  "${courseDetail.enrolledCount} Peserta",
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 9,
                                    color: Colors.brown,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      courseDetail.certificateAvailable == "1"
                      ? Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.brown.shade300),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.brown.shade50,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.workspace_premium, color: Colors.brown, size: 12),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    "Sertifikat",
                                    style: AppFont.ralewaySubtitle.copyWith(
                                      fontSize: 9,
                                      color: Colors.brown,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  courseDetail.description,
                  style: AppFont.ralewayFootnoteLarge,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "Dibuat oleh: ",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(
                      widget.instructorName,
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, color: AppColors.secondary, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Dibuat pada ${formatDate(courseDetail.createdAt ?? '')}",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.more_time, color: AppColors.secondary, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Terakhir update pada ${formatDate(courseDetail.updatedAt ?? '')}",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.category, color: AppColors.secondary, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Kategori: ${widget.categoryName}",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    widget.isEnrolled
                        ? Column(
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Kamu sudah terdaftar di kelas ini",
                                    style: AppFont.ralewaySubtitle.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                "Kelas ini gratis untuk semua pengguna, silahkan klik tombol dibawah ini untuk mendaftar.",
                                style: AppFont.ralewaySubtitle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.customRed,
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 8),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: widget.isEnrolled
                            ? ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Future.delayed(Duration.zero, () {
                                    Navigator.of(context, rootNavigator: true).pushNamed(
                                      RouteNames.classDetail,
                                      arguments: {
                                        'courseId': widget.courseId,
                                        'courseName': courseDetail.title,
                                        'courseDescription': courseDetail.description,
                                      },
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: Colors.black, width: 1),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Lanjut Ke kelas?",
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  enrollmentsViewModel.postEnrollments(
                                    courseId: widget.courseId,
                                    context: context,
                                  );
                                  AppLogger.logInfo("course Id: ${widget.courseId}");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Daftar Kelas",
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      key: _learnSectionKey,
                      children: [
                        Text(
                          "Apa yang akan kamu pelajari?",
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          isExpanded ? courseDetail.sneakpeeks?.length ?? 0 : (courseDetail.sneakpeeks?.length ?? 0).clamp(0, 4),
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check, color: Colors.black54, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    courseDetail.sneakpeeks?[index] ?? '',  
                                    style: AppFont.ralewaySubtitle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if ((courseDetail.sneakpeeks?.length ?? 0) > 4)
                          GestureDetector(
                          onTap: () async {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                            
                            if (isExpanded) {
                              await Future.delayed(const Duration(milliseconds: 300));
                              Scrollable.ensureVisible(
                                _learnSectionKey.currentContext!,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Text(
                            isExpanded ? "Tampilkan lebih sedikit" : "Tampilkan lebih banyak",
                            style: AppFont.ralewaySubtitle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                const SizedBox(height: 14),
                Text(
                  "Kurikulum Kelas",
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "${courseDetail.lessonsCount}",
                      style: AppFont.nunitoFootnoteLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      " Materi ● ",
                      style: AppFont.nunitoFootnoteLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      courseDetail.duration,
                      style: AppFont.nunitoFootnoteLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: lessonViewModel.lessons != null
                      ? List.generate(
                          lessonViewModel.lessons!.length,
                          (index) {
                            final lesson = lessonViewModel.lessons![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${index + 1}.',
                                    style: AppFont.ralewaySubtitle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lesson.title ?? "", 
                                          style: AppFont.ralewaySubtitle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Video - ${lesson.type ?? "lesson"}",  // Changed from lesson.duration to lesson.type
                                          style: AppFont.ralewaySubtitle.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : [], 
                ),
                const SizedBox(height: 8),
                Text(
                  "Kelas ini terdiri dari:",
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.video_settings_rounded, size: 20, color: Colors.grey,),
                    const SizedBox(width: 5),
                    Text(
                      "${courseDetail.duration} berdasarkan video",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.smart_toy_outlined, size: 20, color: Colors.grey,),
                    const SizedBox(width: 5),
                    Text(
                      "Asisstant Pembelajaran",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.auto_awesome_outlined, size: 20, color: Colors.grey,),
                    const SizedBox(width: 5),
                    Text(
                      "Feedback AI Submission",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.phone_android, size: 20, color: Colors.grey,),
                    const SizedBox(width: 5),
                    Text(
                      "Akses di Smartphone, Website",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 20, color: Colors.grey,),
                    const SizedBox(width: 5),
                    Text(
                      courseDetail.certificateAvailable == 1 ? "Sertifikat" : "Tanpa Sertifikat",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Persyaratan:",
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(
                      courseDetail.requirements?.length ?? 0,
                      (index) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(Icons.circle, size: 6, color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              courseDetail.requirements?[index] ?? '', 
                              style: AppFont.ralewaySubtitle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Pengajar",
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Pengajar Kelas ini adalah ${widget.instructorName}",
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary, 
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          courseDetail.instructor.photo ?? 'https://eduapi.senikita.my.id/storage/defaultpic.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey,
                            child: const Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        courseDetail.instructor.expertise ?? '',
                        style: AppFont.ralewaySubtitle.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    ),
      //  if (enrollmentsViewModel.loading) const Loading(opacity: 0.5)
      ],
    );
  }
}
