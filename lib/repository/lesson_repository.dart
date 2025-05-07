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
      AppLogger.logDebug("Error fetching course lessons: $e");
      rethrow;
    }
  }
}