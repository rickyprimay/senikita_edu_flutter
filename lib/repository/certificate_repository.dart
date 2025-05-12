import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';

class CertificateRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<dynamic> fetchCertificate({required String token}) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      final response = await _network.getGetApiResponseWithHeader(AppUrls.getCertificate, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}