import 'dart:io';
import 'package:flutter/material.dart';
import 'package:widya/models/submissions/submission.dart';
import 'package:widya/repository/submission_repository.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:widya/res/widgets/shared_preferences.dart';

class SubmissionViewModel with ChangeNotifier {
  final SubmissionRepository _submissionRepository = SubmissionRepository();

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;
  
  Submission? _submission;
  Submission? get submission => _submission;

  Future<void> fetchSubmission({required int lessonId}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    
    try {
      final sp = await SharedPrefs.instance;
      final String? token = sp.getString("auth_token");
      
      if (token == null) {
        _error = "Token tidak ditemukan";
        _loading = false;
        notifyListeners();
        return;
      }

      final response = await _submissionRepository.fetchSubmission(
        lessonId: lessonId, 
        token: token
      );

      AppLogger.logInfo("Submission response: $response");
      
      if (response != null && response["success"] == true) {
        try {
          final Map<String, dynamic> submissionData = {
            'data': response['data']
          };
          
          _submission = Submission.fromJson(submissionData);
          _error = null;
          AppLogger.logInfo("Submission data parsed successfully");
        } catch (e) {
          _error = "Gagal memproses data submission: ${e.toString()}";
          AppLogger.logError("Submission parsing error: $e");
        }
      } else {
        _error = response?["message"] ?? "Gagal memuat data submission";
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.logError("Fetch submission error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

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

        if (response != null && response["success"] == true) {
          _error = null;

          if (response.containsKey("data")) {
            try {
              final Map<String, dynamic> submissionData = {
                'data': [response['data']]  
              };

              _submission = Submission.fromJson(submissionData);
            } catch (e) {
              AppLogger.logInfo("Note: Couldn't parse submission data: $e");
            }
          }
        } else {
          _error = response != null ? (response["message"] ?? "Unknown error") : "No response from server";
          AppLogger.logError("Submission error: $_error");
        }
      } catch (e) {
        _error = e.toString();
        AppLogger.logError("Submission exception: $e");
      } finally {
        _loading = false;
        notifyListeners();
      }
    }

    Future<void> submitLinkSubmission({
      required int lessonId,
      required String submissionText,
      required int isPublished,
      required BuildContext context,
    }) async {
      _loading = true;
      _error = null;
      notifyListeners();
    
      try {
        final sp = await SharedPrefs.instance;
        final String? token = sp.getString("auth_token");
    
        final response = await _submissionRepository.submitLinkSubmission(
          token: token ?? "",
          lessonId: lessonId,
          submissionText: submissionText,
          isPublished: isPublished,
          context: context,
        );
        
        if (response != null && response["success"] == true) {
          _error = null;
    
          if (response.containsKey("data")) {
            try {
              final Map<String, dynamic> submissionData = {
                'data': [response['data']]  
              };
    
              _submission = Submission.fromJson(submissionData);
            } catch (e) {
              AppLogger.logInfo("Note: Couldn't parse submission data: $e");
            }
          }
        } else {
          _error = response != null ? (response["message"] ?? "Unknown error") : "No response from server";
          AppLogger.logError("Submission error: $_error");
        }
      } catch (e) {
        _error = e.toString();
        AppLogger.logError("Submission exception: $e");
      } finally {
        _loading = false;
        notifyListeners();
      }
    }
}