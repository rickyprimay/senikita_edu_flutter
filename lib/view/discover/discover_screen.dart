import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:senikita_edu/res/widgets/colors.dart';

class Discover extends StatelessWidget {
  final PersistentTabController controller;
  final List<Widget> screens;

  const Discover({
    Key? key,
    required this.controller,
    required this.screens,
  }) : super(key: key);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.search),
        title: "Search",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.white
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.manage_history),
        title: "History",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.white
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.white
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: screens,
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style7,
      navBarHeight: kBottomNavigationBarHeight * 1.4,
    );
  }
}
