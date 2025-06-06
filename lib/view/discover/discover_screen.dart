import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/svg_assets.dart';

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
        icon: SvgIcon(SvgAssets.house, size: 24, color: Colors.white),
        inactiveIcon: SvgIcon(SvgAssets.house, size: 24, color: Colors.black),
        title: "Beranda",
        textStyle: AppFont.crimsonTextSubtitle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.black,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: SvgIcon(SvgAssets.book, size: 24, color: Colors.white),
        inactiveIcon: SvgIcon(SvgAssets.book, size: 24, color: Colors.black),
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
        icon: SvgIcon(SvgAssets.fileHeart, size: 24, color: Colors.white),
        inactiveIcon: SvgIcon(SvgAssets.fileHeart, size: 24, color: Colors.black),
        title: "Karya Seni",
        textStyle: AppFont.crimsonTextSubtitle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.white
      ),
      PersistentBottomNavBarItem(
        icon: SvgIcon(SvgAssets.circleUser, size: 24, color: Colors.white),
        inactiveIcon: SvgIcon(SvgAssets.circleUser, size: 24, color: Colors.black),
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
    return 
    PersistentTabView(
      context,
      controller: controller,
      screens: screens,
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style7,
      backgroundColor: Colors.grey.shade100,
      navBarHeight: kBottomNavigationBarHeight * 1.4,
    );
  }
}
