import 'package:flutter/material.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/models/lessons/lesson_list.dart';
import 'package:widya/repository/lesson_repository.dart';
import 'package:widya/res/widgets/app_urls.dart';
import 'package:widya/res/widgets/logger.dart';

class LessonViewModel with ChangeNotifier {
  final LessonRepository _lessonRepository = LessonRepository();

  bool _loading = false;  
  bool get loading => _loading;
  
  String? _error;
  String? get error => _error;

  List<Lesson>? _lessons;
  List<Lesson>? get lessons => _lessons;

  Future<void> fetchLessonByCourseId(int courseId) async {
    _loading = true;
    _error = null; 
    notifyListeners();  
    final url = AppUrls.getCourseLessons(courseId);
    AppLogger.logInfo("url: $url");

    try {
      final response = await _lessonRepository.getCourseLessons(courseId);

      final lessonListResponse = LessonList.fromJson(response);


      _lessons = lessonListResponse.data;

      AppLogger.logInfo("lessons: ${_lessons?.length}");

      _loading = false;
      notifyListeners();

    } catch (e) {
      _loading = false;
      AppLogger.logError("Error fetching lessons: $e");
      _error = e.toString();
      notifyListeners();  
    }
  }

}