import 'package:flutter/cupertino.dart';
import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';
import 'package:widya/res/widgets/logger.dart';

class LessonRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<dynamic> getCourseLessons(int courseId, String token) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      final response = await _network.getGetApiResponseWithHeader(AppUrls.getCourseLessons(courseId), headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postCompleteLesson(int lessonId, String token, BuildContext context) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      final response = await _network.getPostApiResponseWithHeader(AppUrls.postCompleteLesson(lessonId), headers, null, context);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}