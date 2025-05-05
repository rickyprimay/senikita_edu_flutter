import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool _isLogin = true;

  bool get isLogin => _isLogin;

  void toggleLogin() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void setLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }
}
