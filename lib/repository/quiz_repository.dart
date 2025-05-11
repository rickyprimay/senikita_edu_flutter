import 'package:widya/data/network/network_api_services.dart';
import 'package:widya/res/widgets/app_urls.dart';

class QuizRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<dynamic> fetchQUiz({required int lessonId, required String token}) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      final response = await _network.getGetApiResponseWithHeader(AppUrls.getQuiz(lessonId), headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitQuiz({required int lessonId, required String token, required Map<String, dynamic> body}) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
      final response = await _network.getPostApiResponseWithHeader(AppUrls.submitQuiz(lessonId), headers, body);
      return response;
    } catch (e) {
      rethrow;
    }

}
