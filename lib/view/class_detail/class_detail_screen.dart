import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/res/widgets/svg_assets.dart';
import 'package:widya/view/class_detail/widget/chat_pop_up_widget.dart';
import 'package:widya/view/class_detail/widget/youtube_player_widget.dart';
import 'package:widya/view/class_detail/widget/lesson_list_widget.dart';
import 'package:widya/view/class_detail/widget/lesson_info_widget.dart';
import 'package:widya/view/class_detail/widget/course_header_widget.dart';
import 'package:widya/viewModel/lesson_view_model.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  YoutubePlayerController? _youtubeController;
  
  late LessonViewModel _lessonViewModel;
  
  final ValueNotifier<bool> _isContentLoadingNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isChatOpenNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<int?> _selectedIndexNotifier = ValueNotifier<int?>(null);
  final ValueNotifier<List<int>> _selectedLectureIndicesNotifier = ValueNotifier<List<int>>([]);
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _lessonViewModel = Provider.of<LessonViewModel>(context, listen: false);
    _fetchLessons();
  }
  
  Future<void> _fetchLessons() async {
    _isContentLoadingNotifier.value = true;

    await _lessonViewModel.fetchLessonByCourseId(widget.courseId);

    if (!mounted) return;

    final lessons = _lessonViewModel.lessons;
    if (lessons != null && lessons.isNotEmpty) {
      lessons.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
      int selectedIndex = _findInitialLessonIndex(lessons);
      _selectedIndexNotifier.value = selectedIndex;
      _initializeYoutubeController(lessons[selectedIndex].videoUrl);
    }

    _isContentLoadingNotifier.value = false;
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
  
  void _initializeYoutubeController(String? videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl ?? '');
    _youtubeController?.dispose();
    
    if (videoId != null && videoId.isNotEmpty) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          loop: false,
        ),
      );
    } else {
      _youtubeController = null;
    }
  }
  
  Future<void> _updateSelectedContent(int index) async {
    final lesson = _lessonViewModel.lessons?[index];
    if (lesson == null) return;
    
    _isContentLoadingNotifier.value = true;
    _selectedIndexNotifier.value = index;
    
    if (lesson.videoUrl != null) {
      _initializeYoutubeController(lesson.videoUrl);
    } else {
      _youtubeController?.dispose();
      _youtubeController = null;
    }
    
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      _isContentLoadingNotifier.value = false;
    }
  }
  
  void _openChat() {
    _isChatOpenNotifier.value = true;

    final selectedIndex = _selectedIndexNotifier.value ?? 0;
    final currentLesson = _lessonViewModel.lessons?[selectedIndex];
    final lessonName = currentLesson?.title ?? 'Lesson';
    final lessonDescription = currentLesson?.description ?? 'Description';
    final lessonContent = currentLesson?.content ?? 'Content';

    showChatPopUp(context, widget.courseName, widget.courseDescription, lessonName, lessonDescription, lessonContent);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _isChatOpenNotifier.value = false;
      }
    });
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _tabController.dispose();
    _isContentLoadingNotifier.dispose();
    _isChatOpenNotifier.dispose();
    _selectedIndexNotifier.dispose();
    _selectedLectureIndicesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final hasVideoPlayer = _youtubeController != null;
    
    if (isLandscape && hasVideoPlayer) {
      return _buildLandscapeVideoView();
    }
    
    return _buildPortraitView();
  }

  Widget _buildLandscapeVideoView() {
    return Scaffold(
      body: YoutubePlayerWidget(
        controller: _youtubeController!,
        isFullscreen: true,
      ),
    );
  }

  Widget _buildPortraitView() {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
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
        ),
        
        ValueListenableBuilder<bool>(
          valueListenable: _isContentLoadingNotifier,
          builder: (context, isLoading, _) {
            return isLoading ? const Loading(opacity: 1) : const SizedBox.shrink();
          },
        ),
      ],
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

        return ValueListenableBuilder<bool>(
          valueListenable: _isChatOpenNotifier,
          builder: (context, isChatOpen, _) {
            if (isChatOpen) {
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
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          "Error: Gagal Koneksi Ke Server",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          "Belum ada materi yang tersedia di kelas ini silahkan kembali lagi nanti",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  Widget _buildLessonContent(List<Lesson> lessons) {
    return ValueListenableBuilder<int?>(
      valueListenable: _selectedIndexNotifier,
      builder: (context, selectedIndex, _) {
        final actualSelectedIndex = selectedIndex ?? 0;
        final selectedLesson = lessons[actualSelectedIndex];
        
        return ValueListenableBuilder<bool>(
          valueListenable: _isContentLoadingNotifier,
          builder: (context, isContentLoading, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isContentLoading && selectedLesson.type == 'lesson')
                  _buildLessonMedia(selectedLesson),
                
                CourseHeaderWidget(
                  courseName: widget.courseName,
                  courseDescription: widget.courseDescription,
                ),
                
                _buildTabBar(),
                
                const Divider(color: Colors.grey, height: 1),
                
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ValueListenableBuilder<List<int>>(
                        valueListenable: _selectedLectureIndicesNotifier,
                        builder: (context, completedLectures, _) {
                          return LessonListWidget(
                            lessons: lessons,
                            selectedIndex: actualSelectedIndex, 
                            completedLectures: completedLectures,
                            onLessonSelected: _updateSelectedContent,
                            onMarkComplete: (index) => _markLessonAsComplete(index),
                          );
                        },
                      ),
                      LessonInfoWidget(lesson: selectedLesson),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLessonMedia(Lesson lesson) {
    if (lesson.videoUrl != null && _youtubeController != null) {
      return YoutubePlayerWidget(
        controller: _youtubeController!,
        isFullscreen: false,
      );
    } else {
      return Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              lesson.content ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      );
    }
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
              'Materi',
              style: AppFont.crimsonSubtitle.copyWith(
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
                  'Selengkapnya',
                  style: AppFont.crimsonSubtitle.copyWith(
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
  
  void _markLessonAsComplete(int index) {
    final currentIndices = List<int>.from(_selectedLectureIndicesNotifier.value);
    currentIndices.add(index);
    _selectedLectureIndicesNotifier.value = currentIndices;
    
    _lessonViewModel.postCompleteLesson(_lessonViewModel.lessons![index].id ?? 0, context);
  }
}