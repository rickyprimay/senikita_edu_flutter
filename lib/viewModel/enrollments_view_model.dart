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
  bool _hasNextPage = true;
  bool _isFetchingMore = false;

  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;
  bool get isFetchingMore => _isFetchingMore;

  Future<void> fetchEnrollments({int? page, bool append = false}) async {
  final sp = await SharedPrefs.instance;
  final String? token = sp.getString("auth_token");

  _loading = !append; // kalau append, jangan tampilkan loading utama
  notifyListeners();

  try {
    final response = await _enrollmentsRepository.fetchEnrollments(page: page, token: token ?? "");

    if (response != null) {
      final newListResponse = EnrollmentsListResponse.fromJson(response);
      
      if (append && _enrollmentsListResponse != null) {
        // Append data
        _enrollmentsListResponse!.data.addAll(newListResponse.data);
        _enrollmentsListResponse!.meta = newListResponse.meta;
      } else {
        _enrollmentsListResponse = newListResponse;
      }

      _error = '';
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

  Future<void> postEnrollments({required int courseId, required BuildContext context}) async {
    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");

    final data = {
      "course_id": courseId,
    };

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

}