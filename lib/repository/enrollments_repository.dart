import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';

class EnrollmentsRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<dynamic> fetchEnrollments({int? page, required String token}) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final response = await _network.getGetApiResponseWithHeader(AppUrls.getEnrollments, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> pushEnrollments({required String token, required int courseId, dynamic data}) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final resonse = await _network.getPostApiResponseWithHeader(AppUrls.postEnrollments, headers, data);
      return resonse;
    } catch (e) {
      rethrow;
    }
  }

}
