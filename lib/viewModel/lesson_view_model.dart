import 'package:flutter/material.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/models/lessons/lesson_list.dart';
import 'package:widya/models/lessons/additionals_materials.dart';
import 'package:widya/repository/lesson_repository.dart';
import 'package:widya/res/widgets/app_urls.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:widya/res/widgets/shared_preferences.dart';

class LessonViewModel with ChangeNotifier {
  final LessonRepository _lessonRepository = LessonRepository();

  bool _loading = false;  
  bool get loading => _loading;
  
  String? _error;
  String? get error => _error;

  List<Lesson>? _lessons;
  List<Lesson>? get lessons => _lessons;

  List<AdditionalMaterial>? _additionalMaterials;
  List<AdditionalMaterial>? get additionalMaterials => _additionalMaterials;

  Future<void> fetchLessonByCourseId(int courseId) async {
    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");

    _loading = true;
    _error = null;
    notifyListeners();  

    final url = AppUrls.getCourseLessons(courseId);
    AppLogger.logInfo("url: $url");

    try {
      final response = await _lessonRepository.getCourseLessons(courseId, token ?? "");
      AppLogger.logInfo("response: $response");

      final lessonListResponse = LessonList.fromJson(response);

      _lessons = lessonListResponse.data;
      _additionalMaterials = lessonListResponse.additionalMaterials;

      if (_lessons != null) {
        _lessons!.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
      }

      AppLogger.logInfo("lessons: ${_lessons?.length}");
      AppLogger.logInfo("additionalMaterials: ${_additionalMaterials?.length}");

      _loading = false;
      notifyListeners();

    } catch (e) {
      _loading = false;
      AppLogger.logError("Error fetching lessons: $e");
      _error = e.toString();
      notifyListeners();  
    }
  }

  Future<void> postCompleteLesson(int lessonId, BuildContext context) async {
    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");

    _loading = true;
    _error = null;
    notifyListeners();  

    AppLogger.logInfo("lessonId: $lessonId");

    try {
      final response = await _lessonRepository.postCompleteLesson(lessonId, token ?? "", context);
      AppLogger.logInfo("response: $response");

      _loading = false;
      notifyListeners();

    } catch (e) {
      _loading = false;
      AppLogger.logError("Error completing lesson: $e");
      _error = e.toString();
      notifyListeners();  
    }
  }
}
