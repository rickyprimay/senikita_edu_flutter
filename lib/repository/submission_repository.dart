import 'package:flutter/material.dart';
import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';

class QuizRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<dynamic> submitSubmision({required String token, required Map<String, dynamic> body, required BuildContext context}) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      final response = await _network.getPostApiResponseWithHeader(AppUrls.submitSubmission, headers, body, context);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
