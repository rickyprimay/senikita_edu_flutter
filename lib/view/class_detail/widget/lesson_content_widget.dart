import 'package:flutter/material.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/view/class_detail/widget/course_header_widget.dart';
import 'package:widya/view/class_detail/widget/lesson_info_widget.dart';
import 'package:widya/view/class_detail/widget/lesson_list_widget.dart';
import 'package:widya/view/class_detail/widget/lesson_media_widget.dart';
import 'package:widya/view/class_detail/widget/lesson_tab_bar_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonContentWidget extends StatelessWidget {
  final List<Lesson> lessons;
  final int selectedIndex;
  final List<int> completedLectureIndices;
  final YoutubePlayerController? youtubeController;
  final String? currentVideoUrl;
  final TabController tabController;
  final String courseName;
  final String courseDescription;
  final dynamic additionalMaterial;
  final bool isLoading;
  
  final Function(int) updateSelectedContent;
  final Function(int) markLessonAsComplete;
  final Function(String?) initializeYoutubeController;

  const LessonContentWidget({
    Key? key,
    required this.lessons,
    required this.selectedIndex,
    required this.completedLectureIndices,
    required this.youtubeController,
    required this.currentVideoUrl,
    required this.tabController,
    required this.courseName,
    required this.courseDescription,
    required this.additionalMaterial,
    required this.isLoading,
    required this.updateSelectedContent,
    required this.markLessonAsComplete,
    required this.initializeYoutubeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedLesson = lessons[selectedIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isLoading) 
          LessonMediaWidget(
            lesson: selectedLesson,
            youtubeController: youtubeController,
            currentVideoUrl: currentVideoUrl,
            selectedIndex: selectedIndex,
            initializeYoutubeController: initializeYoutubeController,
            markLessonAsComplete: markLessonAsComplete,
            updateSelectedContent: updateSelectedContent,
          ),
        
        if (selectedLesson.type?.toLowerCase() == "lesson") 
          RepaintBoundary(
            child: CourseHeaderWidget(
              courseName: courseName,
              courseDescription: courseDescription,
            ),
          ),
        
        RepaintBoundary(
          child: LessonTabBarWidget(tabController: tabController),
        ),
        
        const Divider(color: Colors.grey, height: 1),
        
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              LessonListWidget(
                lessons: lessons,
                selectedIndex: selectedIndex, 
                completedLectures: completedLectureIndices,
                onLessonSelected: updateSelectedContent,
                onMarkComplete: markLessonAsComplete,
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
}