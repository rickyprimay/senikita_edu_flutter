import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';

class CourseRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<dynamic> fetchCourse({int? categoryId, String? search, int? page, required token}) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      final url = AppUrls.getCourse(categoryId: categoryId, search: search, page: page);
      final response = await _network.getGetApiResponseWithHeader(url, headers);
      return response;
    } catch (e) {
      rethrow; 
    }
  }

  Future<dynamic> fetchMoreCourse({int? page}) async {
    try {
      final url = AppUrls.getCourseMore(page: page);
      final response = await _network.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow; 
    }
  }

  Future<dynamic> fetchCourseDetail(int courseId) async {
    try {
      final url = AppUrls.getCourseDetail(courseId);
      final response = await _network.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow; 
    }
  }
}
