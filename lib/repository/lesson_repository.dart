import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';
import 'package:widya/res/widgets/logger.dart';

class LessonRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<dynamic> getCourseLessons(int courseId) async {
    try {
      final url = AppUrls.getCourseLessons(courseId);
      final response = await _network.getGetApiResponse(url);
      return response;
    } catch (e) {
      AppLogger.logDebug("Error fetching course lessons: $e");
    }
  }
}