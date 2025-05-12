import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:widya/res/widgets/app_urls.dart';
import 'package:widya/res/widgets/logger.dart';

class TemuBatikRepository {

  Future<dynamic> submitTemuBatik({
    required File file, 
    required String tema, 
  }) async {
    try {
      if (!await file.exists() || await file.length() == 0) {
        return {'success': false, 'detail': 'File is empty or does not exist'};
      }

      var request = http.MultipartRequest(
        'POST', 
        Uri.parse(AppUrls.getTemuBatik)
      );

      request.fields['tema'] = tema;

      String extension = file.path.split('.').last.toLowerCase();
      String contentType;

      switch (extension) {
        case 'jpg':
        case 'jpeg':
          contentType = 'image/jpeg';
          break;
        case 'png':
          contentType = 'image/png';
          break;
        default:
          contentType = 'application/octet-stream';
      }

      var fileStream = http.ByteStream(file.openRead());
      var length = await file.length();

      var multipartFile = http.MultipartFile(
        'file', 
        fileStream,
        length,
        filename: file.path.split('/').last,
        contentType: MediaType.parse(contentType),
      );

      request.files.add(multipartFile);

      AppLogger.logInfo("Sending multipart request to ${AppUrls.feedbackSubmission}");
      AppLogger.logInfo("File: ${file.path}, Size: $length bytes, Type: $contentType");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      AppLogger.logInfo("Response status: ${response.statusCode}");
      AppLogger.logInfo("Response: ${response.body}");

      return json.decode(response.body);
    } catch (e) {
      AppLogger.logError("Error in repository: $e");
      rethrow;
    }
  }
}