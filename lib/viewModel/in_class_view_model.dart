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

  Future<void> generateContent(String userInput) async {
    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey");

    final body = json.encode({
      "model": "gemini-2.0-flash",
      "messages": [
        {
          "role": "system",
          "content": systemPrompt,
        },
        {
          "role": "user",
          "content": userInput,
        }
      ]
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        String generatedContent = responseBody['choices'][0]['message']['content'];
        AppLogger.logDebug("Generated Content: $generatedContent");
      } else {
        AppLogger.logError("Failed to generate content: ${response.statusCode}");
      }
    } catch (error) {
      AppLogger.logError("Error: $error");
    }
  }
}
