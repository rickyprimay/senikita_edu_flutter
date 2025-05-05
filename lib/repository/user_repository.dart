import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';

class UserRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<dynamic> fetchUserDetail(String token) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await _network.getGetApiResponseWithHeader(AppUrls.getDetailPerson, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
