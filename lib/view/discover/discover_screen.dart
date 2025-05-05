import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

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
        title: "Beranda",
        textStyle: AppFont.crimsonTextSubtitle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.search),
        title: "Cari",
        textStyle: AppFont.crimsonTextSubtitle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.white
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.class_),
        title: "Kelas Saya",
        textStyle: AppFont.crimsonTextSubtitle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.white
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profil",
        textStyle: AppFont.crimsonTextSubtitle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
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
