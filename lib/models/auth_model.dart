import 'package:senikita_edu/models/user/user_model.dart';

class Auth {
  final String status;
  final String message;
  final int code;
  final User data;

  Auth({
    required this.status,
    required this.message,
    required this.code,
    required this.data,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    final userJson = json['data'] ?? json['user'];
    if (userJson == null) {
      throw Exception("Neither 'data' nor 'user' found in response");
    }

    return Auth(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      data: User.fromJson(userJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'code': code,
      'data': data.toJson(),
    };
  }
}
