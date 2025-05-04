import 'package:flutter/material.dart';
import 'package:senikita_edu/view/home/home_screen.dart';
import 'package:senikita_edu/view/profile/profile_screen.dart';

const List<Widget> discoverScreens = [
  HomeScreen(),
  Center(child: Text('Search Page')),
  Center(child: Text('Notif Page')),
  ProfileScreen(),
];