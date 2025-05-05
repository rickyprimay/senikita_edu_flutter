import 'package:flutter/material.dart';
import 'package:widya/res/widgets/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  String? _name;
  String? _photo;

  String? get name => _name;
  String? get photo => _photo;

  Future<void> loadUserData() async {
    final sp = SharedPrefs.instance;
    final prefs = await sp;
    _name = prefs.getString("user_name");
    _photo = prefs.getString("user_photo");

    notifyListeners();
  }
}
