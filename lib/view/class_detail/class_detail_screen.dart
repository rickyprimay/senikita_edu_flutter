import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/res/widgets/svg_assets.dart';
import 'package:widya/view/class_detail/widget/chat_pop_up_widget.dart';
import 'package:widya/view/class_detail/widget/landscape_video_widget.dart';
import 'package:widya/view/class_detail/widget/lesson_content_widget.dart';
import 'package:widya/view/class_detail/widget/lesson_state_widget.dart';
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
  
  void _initializeYoutubeController(String? videoUrl) {
    if (_currentVideoUrl != videoUrl) { 
      _currentVideoUrl = videoUrl;
      final videoId = YoutubePlayer.convertUrlToId(videoUrl ?? '');
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

    _youtubeController?.dispose();
    _youtubeController = null;
    _currentVideoUrl = null; 

    if (lesson.videoUrl != null) {
      final videoId = YoutubePlayer.convertUrlToId(lesson.videoUrl ?? '');
      if (videoId != null && videoId.isNotEmpty) {
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
        _currentVideoUrl = lesson.videoUrl;
      }
    }

    if (mounted) {
      setState(() {
        _state.isLoading = false;
      });
    }
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
      return LandscapeVideoWidget(controller: _youtubeController!);
    }
    
    return _buildPortraitView();
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
          return const LessonStateWidget(type: StateType.error);
        }

        final lessons = viewModel.lessons;
        if (lessons == null || lessons.isEmpty) {
          return const LessonStateWidget(type: StateType.empty);
        }

        if (_state.isChatOpen) {
          return const LessonStateWidget(type: StateType.chatActive);
        }
        
        return LessonContentWidget(
          lessons: lessons,
          selectedIndex: _state.selectedIndex ?? 0,
          completedLectureIndices: _state.completedLectureIndices,
          youtubeController: _youtubeController,
          currentVideoUrl: _currentVideoUrl,
          tabController: _tabController,
          courseName: widget.courseName,
          courseDescription: widget.courseDescription,
          additionalMaterial: _lessonViewModel.additionalMaterials,
          isLoading: _state.isLoading,
          updateSelectedContent: _updateSelectedContent,
          markLessonAsComplete: _markLessonAsComplete,
          initializeYoutubeController: _initializeYoutubeController,
        );
      },
    );
  }
  
  void _markLessonAsComplete(int index) {
    _state.markLessonComplete(index);
    setState(() {}); 
    
    _lessonViewModel.postCompleteLesson(_lessonViewModel.lessons![index].id ?? 0, context);
  }
}