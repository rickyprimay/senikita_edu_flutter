import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/res/helpers/date_formatter.dart';
import 'package:widya/res/helpers/duration_formatter.dart';
import 'package:widya/res/helpers/get_level_color.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/viewModel/course_view_model.dart';

class CourseScreen extends StatefulWidget {
  final int courseId;
  final String instructorName;
  final String categoryName;
  const CourseScreen({
    super.key,
    required this.courseId,
    required this.instructorName,
    required this.categoryName,
  });

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {

  final _scrollController = ScrollController();
  final _learnSectionKey = GlobalKey();
  
  bool isExpanded = false;

  final List<String> learnItems = [
    "Membuat karya seni yang berkualitas tinggi",
    "Membangun ekosistem seni yang inklusif",
    "Mendukung seniman lokal dengan sarana inovatif",
    "Meningkatkan keterampilan seni dan kreativitas",
    "Menciptakan peluang kerja di bidang seni",
    "Mengembangkan platform seni yang berkelanjutan",
    "Meningkatkan kesadaran akan seni dan budaya",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<CourseViewModel>(context, listen: false);
      viewModel.fetchCourseDetail(widget.courseId);
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
    final courseDetail = viewModel.courseDetail;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
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
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
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
                Center(
                  child: Text(
                    courseDetail.title,
                    style: AppFont.crimsonTextHeader.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  courseDetail.description,
                  style: AppFont.ralewayFootnoteLarge,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: GetLevelColor(courseDetail.level),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "${courseDetail.level[0].toUpperCase()}${courseDetail.level.substring(1)}",
                    style: AppFont.ralewaySubtitle.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
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
                Row(
                  children: [
                    Text(
                      "Rp 0",
                      style: AppFont.crimsonTextHeader.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Rp 1.000.000",
                      style: AppFont.crimsonTextHeader.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Kelas ini gratis untuk semua pengguna, silahkan klik tombol dibawah ini untuk mendaftar.",
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.customRed,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
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
                const SizedBox(height: 8),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
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
                        "Tambahkan ke Bookmark",
                        style: AppFont.ralewaySubtitle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
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
                          isExpanded ? learnItems.length : learnItems.length.clamp(0, 4),
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check, color: Colors.black54, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    learnItems[index],
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
                        if (learnItems.length > 4)
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
                      "4",
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
                      formatDuration(courseDetail.duration),
                      style: AppFont.nunitoFootnoteLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}.',
                            style: AppFont.ralewaySubtitle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Materi awalan untuk memulai menjadi penari ${index + 1}",
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Video - ${formatDuration(courseDetail.duration)}",
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
