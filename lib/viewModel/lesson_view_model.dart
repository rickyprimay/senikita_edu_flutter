import 'package:flutter/material.dart';
import 'package:widya/models/lessons/lesson.dart';
import 'package:widya/models/lessons/lesson_list.dart';
import 'package:widya/models/lessons/additionals_materials.dart';
import 'package:widya/repository/lesson_repository.dart';
import 'package:widya/res/widgets/app_urls.dart';
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

    try {
      final response = await _lessonRepository.getCourseLessons(courseId, token ?? "");

      final lessonListResponse = LessonList.fromJson(response);

      _lessons = lessonListResponse.data;
      _additionalMaterials = lessonListResponse.additionalMaterials;

      if (_lessons != null) {
        _lessons!.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
      }

      _loading = false;
      notifyListeners();

    } catch (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();  
    }
  }

  Future<bool> postCompleteLesson(int lessonId, BuildContext context) async {
    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");
  
    _error = null;
  
    try {
      final response = await _lessonRepository.postCompleteLesson(lessonId, token ?? "", context);

      if (_lessons != null) {
        for (int i = 0; i < _lessons!.length; i++) {
          if (_lessons![i].id == lessonId) {
            _lessons![i].isCompleted = true;
            break;
          }
        }
      }
      
      notifyListeners();
      return true;  // Return success
      
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;  // Return failure 
    }
  }
}
