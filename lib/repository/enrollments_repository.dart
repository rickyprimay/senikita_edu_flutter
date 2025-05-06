import 'package:flutter/material.dart';
import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';

class EnrollmentsRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<dynamic> fetchEnrollments({int? page, required String token}) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };
      final response = await _network.getGetApiResponseWithHeader(AppUrls.getEnrollments, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postEnrollments({required String token, required int courseId, dynamic data, required BuildContext context}) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    final response = await _network.getPostApiResponseWithHeader(AppUrls.postEnrollments, headers, data, context);
    return response;
  } 
}
