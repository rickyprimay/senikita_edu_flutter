import 'package:flutter/widgets.dart';
import 'package:widya/models/course/course_list_model.dart';
import 'package:widya/models/course/course_model.dart';
import 'package:widya/repository/course_repository.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:widya/res/widgets/shared_preferences.dart';

class CourseViewModel with ChangeNotifier {
  final CourseRepository _courseRepository = CourseRepository();

  bool _loading = false;  
  bool get loading => _loading;
  
  String? _error;
  String? get error => _error;

  List<Course>? _courses;
  List<Course>? get courses => _courses;

  Course? _courseDetail;
  Course? get courseDetail => _courseDetail;

  Future<void> fetchCourses({int? categoryId}) async {
    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");
    _loading = true;
    _error = null; 
    notifyListeners();  

    try {
      final response = await _courseRepository.fetchCourse(categoryId: categoryId);
      AppLogger.logInfo('📥 Course Response: $response');
      AppLogger.logInfo('Token: $token');
      
      final courseListResponse = CourseListResponse.fromJson(response);

      _courses = courseListResponse.data;

      _loading = false;
      notifyListeners();
      AppLogger.logInfo('📥 Course List: ${_courses?.length} courses loaded');
    } catch (e) {
      AppLogger.logError('Error fetching courses: $e');
      _loading = false;
      _error = e.toString();
      notifyListeners();  
    }
  }

  Future<void> fetchCourseDetail(int courseId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _courseRepository.fetchCourseDetail(courseId);
      AppLogger.logInfo('📥 Course Detail Response: $response');

      final courseDetailResponse = Course.fromJson(response['data']);
      
      _courseDetail = courseDetailResponse;

      _loading = false;
      notifyListeners();
      AppLogger.logInfo('📥 Course Detail: ${_courseDetail?.title}');
    } catch (e) {
      AppLogger.logError('Error fetching course detail: $e');
      _loading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

}
