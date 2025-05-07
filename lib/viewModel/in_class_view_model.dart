import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:widya/res/widgets/logger.dart';

class InClassViewModel {
  final String geminiApiKey = "AIzaSyB1rg-gZlHOll5yFz6vJgpOz92vjMfqxqo";

  final String systemPrompt = (
    "Kamu adalah asisten AI di platform Widya, bagian dari SeniKita, yang mendampingi pengguna dalam mempelajari seni "
    "seperti musik, tari, dan kriya. Tugasmu adalah menjawab pertanyaan pengguna dengan cara yang menyenangkan, sabar, dan mendukung. "
    "Berikan penjelasan yang jelas, mudah dipahami, dan sebisa mungkin bantu langsung di dalam platform, tanpa menyarankan mereka untuk mencari bantuan di luar platform seperti guru privat atau kursus lainnya."
  );

  final String geminiEndpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  Future<void> generateContent(String userInput) async {
    final uri = Uri.parse('$geminiEndpoint?key=$geminiApiKey');

    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "role": "system",
          "parts": [
            {"text": systemPrompt}
          ]
        },
        {
          "role": "user",
          "parts": [
            {"text": userInput}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List<dynamic>?;

        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List<dynamic>?;
          final generatedText = parts != null && parts.isNotEmpty ? parts[0]['text'] : null;

          if (generatedText != null) {
            AppLogger.logInfo('Generated response: $generatedText');
          } else {
            AppLogger.logError('No text content generated.');
          }
        } else {
          AppLogger.logError('No candidates returned.');
        }
      } else {
        AppLogger.logError('Request failed: ${response.statusCode} ${response.reasonPhrase}');
        AppLogger.logError('Response body: ${response.body}');
      }
    } catch (e) {
      AppLogger.logError('Error during API call: $e');
    }
  }
  Future<String?> generateContentAndReturnResponse(String userInput) async {
  final uri = Uri.parse('$geminiEndpoint?key=$geminiApiKey');

  final Map<String, dynamic> requestBody = {
    "contents": [
      {
        "role": "system",
        "parts": [
          {"text": systemPrompt}
        ]
      },
      {
        "role": "user",
        "parts": [
          {"text": userInput}
        ]
      }
    ]
  };

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final candidates = data['candidates'] as List<dynamic>?;

      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        final parts = content['parts'] as List<dynamic>?;
        final generatedText = parts != null && parts.isNotEmpty ? parts[0]['text'] : null;
        return generatedText;
      }
    } else {
      AppLogger.logError('Request failed: ${response.statusCode} ${response.reasonPhrase}');
      AppLogger.logError('Response body: ${response.body}');
    }
  } catch (e) {
    AppLogger.logError('Error during API call: $e');
  }
  return null;
}

}
