import 'package:flutter/widgets.dart';
import 'package:widya/models/course/course_list_model.dart';
import 'package:widya/models/course/course_model.dart';
import 'package:widya/repository/course_repository.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:widya/res/widgets/shared_preferences.dart';
import 'package:widya/viewModel/lesson_view_model.dart';

class CourseViewModel with ChangeNotifier {
  final CourseRepository _courseRepository = CourseRepository();
  final LessonViewModel lessonViewModel = LessonViewModel();

  bool _loading = false;  
  bool get loading => _loading;
  
  String? _error;
  String? get error => _error;

  List<Course>? _courses;
  List<Course>? get courses => _courses;

  Course? _courseDetail;
  Course? get courseDetail => _courseDetail;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> fetchCourses({int? categoryId, int? page}) async {
    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");
    _loading = true;
    _error = null; 
    notifyListeners();  

    try {
      final response = await _courseRepository.fetchCourse(categoryId: categoryId, page: page);
      AppLogger.logInfo('Token: $token');
      
      final courseListResponse = CourseListResponse.fromJson(response);

      _courses = courseListResponse.data;

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();  
    }
  }

  Future<void> appendNewCourses() async {
    if (_loading) return;

    _loading = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _courseRepository.fetchMoreCourse(page: nextPage);
      final courseListResponse = CourseListResponse.fromJson(response);

      if (courseListResponse.data.isNotEmpty) {
        _courses = [...?_courses, ...courseListResponse.data];
        _currentPage = nextPage;
      } else {
        _hasMore = false;
      }

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      AppLogger.logError("appendNewCourses error: $e");
      notifyListeners();
    }
  }

  Future<void> fetchCourseDetail(int courseId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _courseRepository.fetchCourseDetail(courseId);

      final courseDetailResponse = Course.fromJson(response['data']);
      
      _courseDetail = courseDetailResponse;
      lessonViewModel.fetchLessonByCourseId(courseId);

      _loading = false;
      notifyListeners();
      
    } catch (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> resetCourses() async {
    _currentPage = 1;
    await fetchCourses(page: 1);
  }

}
