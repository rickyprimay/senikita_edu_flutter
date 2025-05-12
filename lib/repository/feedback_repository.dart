import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:widya/res/widgets/app_urls.dart';
import 'package:widya/res/widgets/logger.dart';

class FeedbackRepository {

  Future<dynamic> submitFeedback({
    required String token, 
    required File imageFile, 
    required String rules, 
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse(AppUrls.feedbackSubmission)
      );
      
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['rules'] = rules;
      
      var fileStream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      
      var multipartFile = http.MultipartFile(
        'file', 
        fileStream,
        length,
        filename: imageFile.path.split('/').last
      );
      
      request.files.add(multipartFile);
      
      AppLogger.logInfo("Sending multipart request to ${AppUrls.feedbackSubmission}");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      AppLogger.logInfo("Response: ${response.body}");
      
      return json.decode(response.body);
    } catch (e) {
      AppLogger.logError("Error in repository: $e");
      rethrow;
    }
  }
}