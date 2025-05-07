import 'package:flutter/material.dart';
import 'package:widya/models/enrollments/enrollments_model.dart';
import 'package:widya/models/enrollments/enrollments_list_model.dart';
import 'package:widya/repository/enrollments_repository.dart';
import 'package:widya/res/widgets/app_urls.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:widya/res/widgets/shared_preferences.dart';
import 'package:widya/utils/utils.dart';

class EnrollmentsViewModel extends ChangeNotifier {
  final EnrollmentsRepository _enrollmentsRepository = EnrollmentsRepository();

  bool _loading = false;  
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  EnrollmentsListResponse? _enrollmentsListResponse;
  EnrollmentsListResponse? get enrollmentsListResponse => _enrollmentsListResponse;

  List<Enrollments> get enrollments {
    return _enrollmentsListResponse?.data ?? [];
  }

  int _currentPage = 1;
  int get currentPage => _currentPage;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> fetchEnrollments({int? page}) async {
    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");
    
    _loading = true;
    notifyListeners();
    try {
      final response = await _enrollmentsRepository.fetchEnrollments(page: page, token: token ?? "");

      if (response != null) {
        try {
          _enrollmentsListResponse = EnrollmentsListResponse.fromJson(response);
          _error = null; 
        } catch (e) {
          _error = 'Failed to parse response';

        }
      } else {
        _error = 'Data not found or empty.';
      }
    } catch (e) {
      _error = 'Failed to load data: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> appendNewEnrollments() async {
    if (_loading) return;
    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");

    _loading = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _enrollmentsRepository.fetchMoreEnrollments(token: token ?? "", page: nextPage);
      final enrollmentsListResponse = EnrollmentsListResponse.fromJson(response);

      if (enrollmentsListResponse.data.isNotEmpty) {
        _enrollmentsListResponse = EnrollmentsListResponse(
          data: [...?_enrollmentsListResponse?.data, ...enrollmentsListResponse.data],
        );
        _currentPage = nextPage;
      } else {
        _hasMore = false;
      }

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      AppLogger.logError("appendNewEnrollments error: $e");
      notifyListeners();
    }
  }

  Future<void> postEnrollments({required int courseId, required BuildContext context}) async {
    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");

    final data = {
      "course_id": courseId,
    };

    AppLogger.logInfo("Data being sent: $data");

    _loading = true;
    notifyListeners();

    AppLogger.logInfo("url: ${AppUrls.postEnrollments}");
    final response = await _enrollmentsRepository.postEnrollments(
        token: token ?? "",
        courseId: courseId,
        data: data,
        context: context,
      );

    try {

      if (response != null && response['success'] == true) {
        _error = '';
        Utils.showToastification('Berhasil', 'Kamu berhasil mendaftar kelas.', true, context);
        Navigator.pop(context);
      } else {
        _error = 'Gagal mendaftar kelas.';
      }
    } catch (e) {
      _error = 'Failed to load data: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> resetEnrollments() async {
    _currentPage = 1;
    await fetchEnrollments(page: 1);
  }
}
