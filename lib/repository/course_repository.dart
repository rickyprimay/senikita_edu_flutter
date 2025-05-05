

import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';

class CourseRepository {
  final NetworkApiServices _network = NetworkApiServices();
  Future<dynamic> fetchCourse() async {
    try {
      final response = await _network.getGetApiResponse(AppUrls.getCourse);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}