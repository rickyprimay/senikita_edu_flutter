import 'package:flutter/foundation.dart';
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
          _error = ''; 
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
      );

    try {
      

      if (response != null && response['success'] == true) {
        _error = '';
        Utils.showToastification('Berhasil', 'Kamu berhasil mendaftar kelas.', true, context);
        Navigator.pop(context, 'goToMyClass');
      } else {
        _error = 'Gagal mendaftar kelas.';
        Utils.showToastification('Gagal', 'Gagal mendaftar kelas, silahkan coba lagi.', false, context);
        AppLogger.logError("Error: $response");
        Navigator.pop(context, 'goToMyClass');

      }
    } catch (e) {
      _error = 'Failed to load data: $e';
      Utils.showToastification('Gagal', 'Gagal mendaftar kelas, silahkan coba lagi.', false, context);
      AppLogger.logError("Error: $e");
      AppLogger.logError("Error: $response");
      Navigator.pop(context, 'goToMyClass');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
