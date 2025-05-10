import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/models/lessons/lesson.dart';
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
  YoutubePlayerController? _youtubeController;
  
  late LessonViewModel _lessonViewModel;
  final _state = ClassDetailState();
  
  bool _videoInitialized = false;
  
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
  
  void _initializeYoutubeController(String? videoUrl) {
    if (!_videoInitialized && videoUrl != null && videoUrl.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(videoUrl);
      if (videoId != null && videoId.isNotEmpty) {
        _youtubeController?.dispose();
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            loop: false,
            enableCaption: false, 
            forceHD: false,
          ),
        );
        _videoInitialized = true;
      }
    }
  }
  
  void _updateSelectedContent(int index) {
    if (_state.selectedIndex == index) return; 
    
    final lesson = _lessonViewModel.lessons?[index];
    if (lesson == null) return;
    
    setState(() {
      _state.selectedIndex = index;
      _state.isLoading = true;
    });
    
    _videoInitialized = false;
    _youtubeController?.dispose();
    _youtubeController = null;
    
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _state.isLoading = false;
        });
      }
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
    _youtubeController?.dispose();
    _tabController.dispose();
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
        
        if (_state.isLoading)
          const Loading(opacity: 1),
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
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_state.isLoading && selectedLesson.type == 'lesson') 
          _buildLessonMedia(selectedLesson),
        
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
              LessonInfoWidget(lesson: selectedLesson),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLessonMedia(Lesson lesson) {
    if (lesson.videoUrl != null && !_videoInitialized) {
      _initializeYoutubeController(lesson.videoUrl);
    }
    
    if (lesson.videoUrl != null && _youtubeController != null) {
      return RepaintBoundary(
        child: YoutubePlayerWidget(
          controller: _youtubeController!,
          isFullscreen: false,
        ),
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
        tabs: const [
          Tab(
            child: Text(
              'Materi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _markLessonAsComplete(int index) {
    _state.markLessonComplete(index);
    setState(() {}); 
    
    _lessonViewModel.postCompleteLesson(_lessonViewModel.lessons![index].id ?? 0, context);
  }
}