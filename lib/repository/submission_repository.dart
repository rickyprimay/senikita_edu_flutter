import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';
import 'package:widya/res/widgets/logger.dart';

class SubmissionRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<dynamic> fetchSubmission({required int lessonId, required String token}) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      final response = await _network.getGetApiResponseWithHeader(AppUrls.getSubmissionHistory(lessonId), headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitSubmission({
    required String token, 
    required int lessonId,
    required String submissionText,
    required File imageFile,
    required int isPublished,
    required BuildContext context
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse(AppUrls.submitSubmission)
      );
      
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      
      request.fields['lesson_id'] = lessonId.toString();
      request.fields['submission'] = submissionText;
      request.fields['is_published'] = isPublished.toString();
      
      var fileStream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      
      var multipartFile = http.MultipartFile(
        'file_path', 
        fileStream,
        length,
        filename: imageFile.path.split('/').last
      );
      
      request.files.add(multipartFile);
      
      AppLogger.logInfo("Sending multipart request to ${AppUrls.submitSubmission}");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      AppLogger.logInfo("Response: ${response.body}");
    } catch (e) {
      AppLogger.logError("Error in repository: $e");
      rethrow;
    }
  }
}