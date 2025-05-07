import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/view/class_detail/widget/chat_pop_up.dart';
import 'package:widya/viewModel/in_class_view_model.dart';
import 'package:widya/viewModel/lesson_view_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

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

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  late LessonViewModel lessonViewModel;
  int? _selectedIndex;
  YoutubePlayerController? _youtubeController;
  bool _isContentLoading = false; // Untuk transisi loading saat ganti video/materi

  @override
  void initState() {
    super.initState();
    lessonViewModel = Provider.of<LessonViewModel>(context, listen: false);
    _fetchLessons();
  }

  void _fetchLessons() async {
    setState(() {
      _isContentLoading = true;
    });
    await lessonViewModel.fetchLessonByCourseId(widget.courseId);
    if (!mounted) return;

    final lessons = lessonViewModel.lessons;
    if (lessons != null && lessons.isNotEmpty) {
      _selectedIndex = 0;
      _initializeYoutubeController(lessons[0].videoUrl);
    }
    setState(() {
      _isContentLoading = false;
    });
  }

  void _initializeYoutubeController(String? videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl ?? '');
    _youtubeController?.dispose(); // Dispose controller lama
    if (videoId != null && videoId.isNotEmpty) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    } else {
      _youtubeController = null; // Jika bukan video, null-kan controller
    }
  }

  void _updateSelectedContent(int index) async {
    final lesson = lessonViewModel.lessons?[index];
    if (lesson == null) return;

    setState(() {
      _isContentLoading = true;
      _selectedIndex = index;
    });

    if (lesson.videoUrl != null) {
      _initializeYoutubeController(lesson.videoUrl);
    } else {
      _youtubeController?.dispose();
      _youtubeController = null;
    }

    await Future.delayed(const Duration(milliseconds: 300)); // Efek transisi halus
    if (mounted) {
      setState(() {
        _isContentLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _openChat() {
    showChatPopUp(context);
  }

  @override
  Widget build(BuildContext context) {
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
            child: Consumer<LessonViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.error != null) {
                  return Center(child: Text('Error: ${viewModel.error}'));
                }

                final lessons = viewModel.lessons;
                if (lessons == null || lessons.isEmpty) {
                  return const Center(child: Text('No lessons available.'));
                }

                final selectedLesson = lessons[_selectedIndex ?? 0];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isContentLoading
                        ? const Center(child: CircularProgressIndicator())
                        : selectedLesson.type == 'lesson' && selectedLesson.videoUrl != null && _youtubeController != null
                            ? YoutubePlayer(
                                controller: _youtubeController!,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: AppColors.primary,
                              )
                            : selectedLesson.type == 'lesson'
                                ? Expanded(
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          selectedLesson.content ?? '',
                                          style: AppFont.ralewaySubtitle.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),

                    // Course info
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.courseName,
                              style: AppFont.crimsonTextHeader.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              )),
                          const SizedBox(height: 4),
                          Text(widget.courseDescription,
                              style: AppFont.ralewayHeader.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              )),
                        ],
                      ),
                    ),

                    // Materi tab
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColors.primary, width: 2),
                              ),
                            ),
                            child: Text('Materi',
                                style: AppFont.crimsonTextHeader.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text('Selengkapnya',
                                style: AppFont.crimsonTextHeader.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey, height: 1),

                    // Daftar Materi List
                    Expanded(
                      child: ListView.builder(
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];
                          final isSelected = _selectedIndex == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            color: isSelected ? AppColors.primary.withAlpha(55) : Colors.transparent,
                            child: InkWell(
                              onTap: () => _updateSelectedContent(index),
                              splashColor: AppColors.primary.withAlpha(44),
                              highlightColor: AppColors.primary.withAlpha(22),
                              child: ListTile(
                                title: Text(lesson.title ?? '',
                                    style: AppFont.ralewaySubtitle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )),
                                subtitle: Text(
                                  'Video ${lesson.duration != null ? ' - ${lesson.duration} menit' : ''}',
                                  style: AppFont.nunitoSubtitle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _openChat,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.chat, color: Colors.white, size: 25),
          ),
        ),

        // Optional Loading overlay (biar halus saat fetch/ganti content)
        if (_isContentLoading) const Loading(opacity: 0.5),
      ],
    );
  }
}