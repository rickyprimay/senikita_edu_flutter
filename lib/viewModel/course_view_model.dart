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
      final response = await _courseRepository.fetchCourse(categoryId: categoryId, page: page, token: token ?? "");
      AppLogger.logInfo("Response: $response");

      final courseListResponse = CourseListResponse.fromJson(response);

      _courses = courseListResponse.data;
      _currentPage = page ?? 1;  // reset current page
      _hasMore = true;           // reset hasMore dulu

      if (response['meta'] != null && response['meta']['pagination'] != null) {
        final pagination = response['meta']['pagination'];
        final int totalPages = pagination['total_pages'] ?? 1;

        // Kalau cuma 1 halaman, langsung set hasMore false
        if (_currentPage >= totalPages || pagination['links']['next'] == null) {
          _hasMore = false;
        }
      } else {
        _hasMore = false;
      }

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      AppLogger.logError("Error fetching courses: $e");
      notifyListeners();
    }
  }

  Future<void> searchCourses(String searchQuery) async {
    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");

    _loading = true;
    _error = null; 
    notifyListeners();  

    try {
      final response = await _courseRepository.fetchCourse(search: searchQuery, token: token ?? "");
      AppLogger.logInfo("Search Response: $response");

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
    if (_loading || !_hasMore) return; // <-- tambahkan ini!

    _loading = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _courseRepository.fetchMoreCourse(page: nextPage);
      final courseListResponse = CourseListResponse.fromJson(response);

      if (courseListResponse.data.isNotEmpty) {
        _courses = [...?_courses, ...courseListResponse.data];
        _currentPage = nextPage;
      }

      if (response['meta'] != null && response['meta']['pagination'] != null) {
        final pagination = response['meta']['pagination'];
        final int totalPages = pagination['total_pages'] ?? 1;

        if (_currentPage >= totalPages || pagination['links']['next'] == null) {
          _hasMore = false;
        }
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
    _hasMore = true;
    await fetchCourses(page: 1);
  }

}
