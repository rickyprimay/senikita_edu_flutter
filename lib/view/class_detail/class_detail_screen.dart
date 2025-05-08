import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/utils/utils.dart';
import 'package:widya/view/class_detail/widget/chat_pop_up.dart';
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
      _selectedIndexNotifier.value = 0;
      _initializeYoutubeController(lessons[0].videoUrl);
    }
    
    _isContentLoadingNotifier.value = false;
  }
  
  void _initializeYoutubeController(String? videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl ?? '');
    _youtubeController?.dispose();
    
    if (videoId != null && videoId.isNotEmpty) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
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
  
  void _markLessonAsComplete(int index) {
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
        final currentIndices = List<int>.from(_selectedLectureIndicesNotifier.value);
        currentIndices.add(index);
        _selectedLectureIndicesNotifier.value = currentIndices;
        
        Navigator.of(context).pop();
        _lessonViewModel.postCompleteLesson(_lessonViewModel.lessons![index].id ?? 0, context); 
        Utils.showToastification("Berhasil", "Sesi berhasil diselesaikan", true, context);
      },
      confirmBtnColor: AppColors.primary,
    );
  }
  
  Widget _buildMoreInfo(Lesson selectedLesson) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              selectedLesson.title ?? '',
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
                  'Durasi ${selectedLesson.duration ?? '30 menit'} Menit',
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
              selectedLesson.description ?? 'Pada kesempatan kali ini kita akan belajar pergerakan tangan',
              style: AppFont.ralewaySubtitle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              'Isi Konten : ${selectedLesson.content}',
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
  
  Widget _buildLessonList(List<Lesson> lessons, int? selectedIndex, List<int> completedLectures) {
    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        final isSelected = selectedIndex == index;
        final isLectureCompleted = completedLectures.contains(index) || (lesson.isCompleted ?? false);
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color: isSelected ? AppColors.primary.withAlpha(55) : Colors.transparent,
          child: InkWell(
            onTap: () {
              if (selectedIndex != index) {
                _updateSelectedContent(index);
              }
            },
            splashColor: AppColors.primary.withAlpha(44),
            highlightColor: AppColors.primary.withAlpha(22),
            child: ListTile(
              leading: isLectureCompleted
                ? Icon(Icons.check_circle, color: AppColors.primary)
                : IconButton(
                    icon: Icon(
                      isLectureCompleted ? Icons.check_circle_outline : Icons.circle_outlined,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      if (index == selectedIndex) {
                        _markLessonAsComplete(index);
                      } else {
                        Utils.showToastification(
                          "Gagal", 
                          "Selesaikan hanya bisa diakses di sesi yang sedang dipelajari", 
                          false, 
                          context
                        );
                      }
                    }
                  ),
              title: Text(
                lesson.title ?? '',
                style: AppFont.ralewaySubtitle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                )
              ),
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
    );
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
              builder: (context, viewModel, _) {
                if (viewModel.error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        "Error: Gagal Koneksi Ke Server",
                        textAlign: TextAlign.center,
                        style: AppFont.ralewaySubtitle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }

                final lessons = viewModel.lessons;
                if (lessons == null || lessons.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        "Belum ada materi yang tersedia di kelas ini silahkan kembali lagi nanti",
                        textAlign: TextAlign.center,
                        style: AppFont.ralewaySubtitle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
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
                                  if (selectedLesson.videoUrl != null && _youtubeController != null)
                                    YoutubePlayer(
                                      controller: _youtubeController!,
                                      showVideoProgressIndicator: true,
                                      progressIndicatorColor: AppColors.primary,
                                    )
                                  else
                                    Expanded(
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
                                    ),
                                
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.courseName,
                                        style: AppFont.crimsonTextHeader.copyWith(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        )
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.courseDescription,
                                        style: AppFont.ralewayHeader.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                
                                Container(
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
                                          style: AppFont.crimsonTextHeader.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          'Selengkapnya',
                                          style: AppFont.crimsonTextHeader.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const Divider(color: Colors.grey, height: 1),
                                
                                Expanded(
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      ValueListenableBuilder<List<int>>(
                                        valueListenable: _selectedLectureIndicesNotifier,
                                        builder: (context, completedLectures, _) {
                                          return _buildLessonList(
                                            lessons, 
                                            actualSelectedIndex,
                                            completedLectures,
                                          );
                                        },
                                      ),
                                      _buildMoreInfo(selectedLesson),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
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
        
        ValueListenableBuilder<bool>(
          valueListenable: _isContentLoadingNotifier,
          builder: (context, isLoading, _) {
            return isLoading ? const Loading(opacity: 0.5) : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
