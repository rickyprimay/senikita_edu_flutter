

import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';

class GalleryRepository {
  final NetworkApiServices _network = NetworkApiServices();
  Future<dynamic> fetchGallery() async {
    try {
      final response = await _network.getGetApiResponse(AppUrls.getPublishedGallery);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}