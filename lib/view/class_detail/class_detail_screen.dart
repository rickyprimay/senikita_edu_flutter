import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/res/widgets/svg_assets.dart';
import 'package:widya/res/widgets/video_player_screen.dart';
import 'package:widya/utils/routes/routes_names.dart';
import 'package:widya/view/class_detail/widget/chat_pop_up_widget.dart';
import 'package:widya/view/class_detail/widget/lesson_list_widget.dart';
import 'package:widya/view/class_detail/widget/lesson_info_widget.dart';
import 'package:widya/view/class_detail/widget/course_header_widget.dart';
import 'package:widya/viewModel/lesson_view_model.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ClassDetailState {
  bool isLoading = true;
  bool isChatOpen = false;
  int? selectedIndex;
  List<int> completedLectureIndices = [];
  
  void markLessonComplete(int index) {
    if (!completedLectureIndices.contains(index)) {
      completedLectureIndices.add(index);
    }
  }
}

class ClassDetailScreen extends StatefulWidget {
  final int courseId;
  final String courseName;
  final String courseDescription;

  const ClassDetailScreen({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.courseDescription,
  });

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  late LessonViewModel _lessonViewModel;
  final _state = ClassDetailState();
  String? _currentVideoUrl;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _lessonViewModel = Provider.of<LessonViewModel>(context, listen: false);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLessons();
    });
  }
  
  Future<void> _fetchLessons() async {
    if (mounted) {
      setState(() {
        _state.isLoading = true;
      });
    }

    await _lessonViewModel.fetchLessonByCourseId(widget.courseId);

    if (!mounted) return;

    final lessons = _lessonViewModel.lessons;
    if (lessons != null && lessons.isNotEmpty) {
      lessons.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
      int selectedIndex = _findInitialLessonIndex(lessons);
      
      setState(() {
        _state.selectedIndex = selectedIndex;
        _state.isLoading = false;
      });
    }
    else {
      setState(() {
        _state.isLoading = false;
      });
    }
  }
  
  int _findInitialLessonIndex(List<Lesson> lessons) {
    for (int i = 0; i < lessons.length; i++) {
      if (lessons[i].isCompleted == false) {
        return i;
      }
    }
    
    if (lessons.isNotEmpty) {
      int highestOrder = lessons.fold(0, (max, lesson) => 
          (lesson.order ?? 0) > max ? (lesson.order ?? 0) : max);
          
      for (int i = 0; i < lessons.length; i++) {
        if ((lessons[i].order ?? 0) == highestOrder) {
          return i;
        }
      }
    }
    
    return 0;
  }
  
  String? _getYoutubeVideoId(String? videoUrl) {
    if (videoUrl == null || videoUrl.isEmpty) return null;
    return YoutubePlayer.convertUrlToId(videoUrl);
  }
  
  void _openVideoPlayer(String videoUrl, String title, String description, String content) {
    final videoId = _getYoutubeVideoId(videoUrl);
    if (videoId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            videoId: videoId,
            videoTitle: title,
            videoDescription: description,
            videoContent: content,
          ),
        ),
      );
    }
  }
  
  void _updateSelectedContent(int index) {
    final currentIndex = _state.selectedIndex ?? 0;
    final currentLesson = _lessonViewModel.lessons?[currentIndex];
    final targetLesson = _lessonViewModel.lessons?[index];

    if (targetLesson == null) return;

    bool canNavigate = index <= currentIndex || 
                       currentLesson?.isCompleted == true || 
                       _state.completedLectureIndices.contains(currentIndex);

    if (index == 0) canNavigate = true;

    if (!canNavigate) {
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
                    'Pelajaran Terkunci',
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
                        Icons.lock_outline_rounded,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Pelajaran Ini Belum Dapat Diakses',
                    style: AppFont.ralewaySubtitle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Selesaikan pelajaran saat ini terlebih dahulu untuk membuka materi selanjutnya.',
                    style: AppFont.ralewaySubtitle.copyWith(
                      fontSize: 14,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
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
                        "Mengerti",
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
          );
        },
      );
      return;
    }

    if (_state.selectedIndex == index) return;

    setState(() {
      _state.selectedIndex = index;
      _state.isLoading = false;
      _currentVideoUrl = targetLesson.videoUrl;
    });
  }
  
  void _openChat() {
    setState(() {
      _state.isChatOpen = true;
    });

    final selectedIndex = _state.selectedIndex ?? 0;
    final currentLesson = _lessonViewModel.lessons?[selectedIndex];
    final lessonName = currentLesson?.title ?? 'Lesson';
    final lessonDescription = currentLesson?.description ?? 'Description';
    final lessonContent = currentLesson?.content ?? 'Content';

    showChatPopUp(context, widget.courseName, widget.courseDescription, lessonName, lessonDescription, lessonContent);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _state.isChatOpen = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildMainContent(),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: _openChat,
        backgroundColor: AppColors.primary,
        child: SvgIcon(SvgAssets.botMessageSquare, size: 25, color: Colors.white)
      ),
    );
  }

  Widget _buildMainContent() {
    return Consumer<LessonViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.error != null) {
          return _buildErrorState();
        }

        final lessons = viewModel.lessons;
        if (lessons == null || lessons.isEmpty) {
          return _buildEmptyState();
        }

        if (_state.isLoading) {
          return const Center(child: Loading(opacity: 1));
        }

        if (_state.isChatOpen) {
          return const Center(
            child: Text(
              'Chat sedang aktif.\nKonten kelas dijeda sementara.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        
        return _buildLessonContent(lessons);
      },
    );
  }

  Widget _buildErrorState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          "Error: Gagal Koneksi Ke Server",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          "Belum ada materi yang tersedia di kelas ini silahkan kembali lagi nanti",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildLessonContent(List<Lesson> lessons) {
    final selectedIndex = _state.selectedIndex ?? 0;
    final selectedLesson = lessons[selectedIndex];
    final additionalMaterial = _lessonViewModel.additionalMaterials;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLessonMedia(selectedLesson),
        
        if (selectedLesson.type?.toLowerCase() == "lesson") 
          RepaintBoundary(
            child: CourseHeaderWidget(
              courseName: widget.courseName,
              courseDescription: widget.courseDescription,
            ),
          ),
        
        RepaintBoundary(
          child: _buildTabBar(),
        ),
        
        const Divider(color: Colors.grey, height: 1),
        
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              LessonListWidget(
                lessons: lessons,
                selectedIndex: selectedIndex, 
                completedLectures: _state.completedLectureIndices,
                onLessonSelected: _updateSelectedContent,
                onMarkComplete: _markLessonAsComplete,
              ),
              LessonInfoWidget(
                lesson: selectedLesson,
                additionalMaterial: additionalMaterial,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLessonMedia(Lesson lesson) {
    if (lesson.type?.toLowerCase() == "lesson" && lesson.videoUrl != null) {
      final videoId = _getYoutubeVideoId(lesson.videoUrl);
      
      if (videoId != null) {
        final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
        
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Image.network(
                  thumbnailUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(
                        child: Icon(Icons.video_library, size: 40, color: Colors.grey),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Play button overlay
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _openVideoPlayer(lesson.videoUrl!, lesson.title ?? "", lesson.description ?? "", lesson.content ?? "");
                  },
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Video title overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  lesson.title ?? "Video Pembelajaran",
                  style: AppFont.ralewaySubtitle.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        );
      }
    } else if (lesson.type?.toLowerCase() == "final") {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column (
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
                        lesson.isCompleted != true ? Icons.assignment_outlined : Icons.check_circle_outline_rounded,
                        size: 60,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        lesson.isCompleted != true ? "Siap untuk melakukan Submission?" : "Anda sudah menyelesaikan Kelas ini",
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
                Column(
                  children: [
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pushNamed(
                                    RouteNames.submissionHistory,
                                    arguments: {
                                      "lessonId": lesson.id,
                                      "lessonName": lesson.title,
                                      "submissionType": lesson.submissionType,
                                    },
                                  );
                                },
                                icon: const Icon(Icons.comment_outlined, size: 18),
                                label: Text(
                                  "Cek Hasil Submit",
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  side: BorderSide(color: AppColors.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                    
                            const SizedBox(width: 16),
                    
                            if (lesson.isCompleted != true)
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pushNamed(
                                    RouteNames.submission,
                                    arguments: {
                                      "lessonId": lesson.id,
                                      "submissionType": lesson.submissionType,
                                    },
                                  );
                                },
                                icon: const Icon(Icons.upload_file_outlined, size: 18),
                                label: Text(
                                  "Submit",
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (lesson.submissionType == "file" && lesson.isCompleted != true)
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pushNamed(
                                RouteNames.feedback,
                                arguments: {
                                  "lessonId": lesson.id,
                                  "rules": lesson.content
                                },
                              );
                            },
                            icon: const Icon(Icons.smart_toy_outlined, size: 18),
                            label: Text(
                              "Minta Feedback AI",
                              style: AppFont.ralewaySubtitle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tertiary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                      ]
                    ),
                    const SizedBox(height: 4),
                  ]
                ),
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
            )
          ),
        )
      );
    } else {
      final isQuiz = lesson.type?.toLowerCase() == "quiz";
      final selectedIndex = _state.selectedIndex ?? 0;

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
                        lesson.isCompleted != true ? Icons.quiz_rounded : Icons.check_circle_outline_rounded,
                        size: 60,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        isQuiz && lesson.isCompleted != true ? "Siap untuk Mengukur Pemahamanmu?" : "Anda sudah menyelesaikan Quiz ini",
                        style: AppFont.crimsonTextHeader.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        lesson.isCompleted != true ? "Jawab pertanyaan berikut untuk menguji pemahaman kamu tentang materi yang telah dipelajari" : "Selamat! Kamu telah menyelesaikan quiz ini",
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

                Container(
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
                      lesson.isCompleted == true
                       ? InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pushNamed(RouteNames.quizHistory);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.history_edu, color: AppColors.primary, size: 22),
                                const SizedBox(width: 12),
                                Text(
                                  "Cek Riwayat Quiz",
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios_rounded, 
                                  color: AppColors.secondary,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox()
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (isQuiz)
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),  
                    child: 
                    lesson.isCompleted != true
                    ? ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.of(context, rootNavigator: true).pushNamed(
                          RouteNames.quiz,
                          arguments: {
                            "quizTitle": lesson.title,
                            "timeLimit": lesson.duration, 
                            "lessonId": lesson.id,
                            "courseId": widget.courseId,
                          },
                        );

                        if (result is Map && result['isPassed'] == true) {
                          _markLessonAsComplete(selectedIndex);

                          final lessons = _lessonViewModel.lessons;
                          if (lessons != null && selectedIndex < lessons.length - 1) {
                            _updateSelectedContent(selectedIndex + 1);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
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
                    )
                    : Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.primary,
                      ),
                      child: Center(
                        child: Text(
                          "Kamu telah menyelesaikan quiz ini",
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(
            child: Text(
              'Pelajaran',
              style: AppFont.crimsonTextSubtitle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 16),
                SizedBox(width: 4),
                Text(
                  'Materi Tambahan',
                  style: AppFont.crimsonTextSubtitle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _markLessonAsComplete(int index) async {
    _state.markLessonComplete(index);

    if (_lessonViewModel.lessons != null && _lessonViewModel.lessons!.length > index) {
      final lessonId = _lessonViewModel.lessons![index].id ?? 0;
      await _lessonViewModel.postCompleteLesson(lessonId, context);

      await _lessonViewModel.fetchLessonByCourseId(widget.courseId);
    }

    if (mounted) {
      setState(() {});
    }
  }
}