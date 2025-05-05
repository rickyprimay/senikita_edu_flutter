import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:senikita_edu/res/widgets/discover_list.dart';
import 'package:senikita_edu/utils/routes/routes_names.dart';
import 'package:senikita_edu/view/discover/discover_screen.dart';
import 'package:senikita_edu/view/home/home_screen.dart';
import 'package:senikita_edu/view/login/login_screen.dart';
import 'package:senikita_edu/view/my_class/my_class_screen.dart';
import 'package:senikita_edu/view/profile/profile_screen.dart';
import 'package:senikita_edu/view/senikita/senikita_screen.dart';
import 'package:senikita_edu/view/splash/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case (RouteNames.login):
        return MaterialPageRoute(builder: (BuildContext context) => const LoginScreen());
      case (RouteNames.discover):
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return Discover(
            controller: PersistentTabController(initialIndex: 0),
            screens: discoverScreens,
          );
        },
      );
      case (RouteNames.home):
        return MaterialPageRoute(builder: (BuildContext context) => const HomeScreen());
      case (RouteNames.splashScreen):
        return MaterialPageRoute(builder: (BuildContext context) => const SplashScreen());
      case (RouteNames.profile):
        return MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen());
      case (RouteNames.myClass):
        return MaterialPageRoute(builder: (BuildContext context) => const MyClassScreen());
      case (RouteNames.seniKita):
        return MaterialPageRoute(builder: (BuildContext context) => const SeniKitaScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("No route is configured"),
            ),
          ),
        );
    }
  }
}