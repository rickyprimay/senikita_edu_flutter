import 'package:senikita_edu/data/network/network_api_services.dart';
import 'package:senikita_edu/res/widgets/app_urls.dart';

class AuthRepository {
  final NetworkApiServices _network = NetworkApiServices();
  Future<dynamic> apiLogin(dynamic data) async {
    try {
      final response = await _network.getPostApiResponse(AppUrls.loginEndPoint, data);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}