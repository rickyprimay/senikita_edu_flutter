

import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';

class CategoryRepository {
  final NetworkApiServices _network = NetworkApiServices();
  Future<dynamic> fetchCategory() async {
    try {
      final response = await _network.getGetApiResponse(AppUrls.getCategory);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}