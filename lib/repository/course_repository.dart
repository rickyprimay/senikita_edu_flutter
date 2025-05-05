import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';

class CourseRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<dynamic> fetchCourse({int? categoryId, String? search}) async {
    try {
      final url = AppUrls.getCourse(categoryId: categoryId, search: search);
      
      final response = await _network.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow; 
    }
  }
}
