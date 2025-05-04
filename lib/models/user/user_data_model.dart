import 'user_model.dart';

class UserDataModel {
  final User user;
  final String token;

  UserDataModel({required this.user, required this.token});

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }
}
