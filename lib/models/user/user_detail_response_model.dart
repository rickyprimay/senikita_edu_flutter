import 'package:senikita_edu/models/user/user_data_model.dart';

class UserDetailResponse {
  final bool success;
  final String message;
  final UserDataModel data;

  UserDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserDetailResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailResponse(
      success: json['success'],
      message: json['message'],
      data: UserDataModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}
