import 'package:flutter/material.dart';
import 'package:senikita_edu/res/widgets/shared_preferences.dart';
import 'package:senikita_edu/utils/routes/routes_names.dart';

class SplashService {
  static void checkAuthentication(BuildContext context) async {
    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");

    await Future.delayed(const Duration(seconds: 3));

    if (token == null || token.isEmpty) {
      Navigator.pushNamed(context, RouteNames.login);
    } else {
      Navigator.pushNamed(context, RouteNames.discover);
    }
  }
}
