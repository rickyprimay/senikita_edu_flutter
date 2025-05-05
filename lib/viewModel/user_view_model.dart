import 'package:flutter/cupertino.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:widya/res/widgets/shared_preferences.dart';
import 'package:widya/repository/user_repository.dart';
import 'package:flutter/material.dart'; 
import 'package:widya/utils/utils.dart';

class UserViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  dynamic _userDetail;
  dynamic get userDetail => _userDetail;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<bool> saveUser(String token) async {
    final sp = await SharedPrefs.instance;
    sp.setString("auth_token", token);
    notifyListeners();
    return true;
  }

  Future<bool> removeUser() async {
    final sp = await SharedPrefs.instance;
    sp.remove("auth_token");
    notifyListeners();
    return true;
  }

  Future<void> fetchUserDetail(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final sp = await SharedPrefs.instance;
      final String? token = sp.getString("auth_token");

      if (token == null) {
        throw Exception("No auth token found");
      }

      final response = await _userRepository.fetchUserDetail(token);
      AppLogger.logInfo('📥 User Detail Response: $response');

      if (response['success'] == true && response['data'] != null) {
        final userData = response['data']['user'];
        
        await sp.setString('user_name', userData['name']);
        await sp.setString('user_email', userData['email']);
        await sp.setString('user_photo', userData['photo']);
      } else {
        throw Exception("Failed to fetch user data");
      }

      _userDetail = response;

    } catch (e) {
      Utils.flushBarErrorMessage(_error!, context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
