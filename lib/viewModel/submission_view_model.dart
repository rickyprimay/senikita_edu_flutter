import 'dart:io';

import 'package:flutter/material.dart';
import 'package:widya/repository/submission_repository.dart';
import 'package:widya/res/widgets/shared_preferences.dart';

class SubmissionViewModel with ChangeNotifier {
  final SubmissionRepository _submissionRepository = SubmissionRepository();

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> submitSubmission({
    required int lessonId,
    required String submissionText,
    required String filePath,
    required int isPublished,
    required BuildContext context,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
  
    try {
      final sp = await SharedPrefs.instance;
      final String? token = sp.getString("auth_token");
  
      final File imageFile = File(filePath);
      
      if (!await imageFile.exists()) {
        _error = "File tidak ditemukan: $filePath";
        _loading = false;
        notifyListeners();
        return;
      }
  
      final response = await _submissionRepository.submitSubmission(
        token: token ?? "",
        lessonId: lessonId,
        submissionText: submissionText,
        imageFile: imageFile,
        isPublished: isPublished,
        context: context,
      );
  
      // Handle response as before
      // ...
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
    }
  }

}