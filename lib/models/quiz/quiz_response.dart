import 'package:widya/models/quiz/quiz_data_wrapper.dart';

class QuizResponse {
  final bool success;
  final String message;
  final QuizDataWrapper? data;

  QuizResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    QuizDataWrapper? dataWrapper;
    if (json['data'] != null) {
      dataWrapper = QuizDataWrapper.fromJson(json['data']);
    }
    
    return QuizResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: dataWrapper,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {
      'success': success,
      'message': message,
    };
    
    if (data != null) {
      result['data'] = data!.toJson();
    }
    
    return result;
  }
}