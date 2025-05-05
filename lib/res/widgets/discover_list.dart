import 'package:flutter/material.dart';
import 'package:widya/view/home/home_screen.dart';
import 'package:widya/view/my_class/my_class_screen.dart';
import 'package:widya/view/profile/profile_screen.dart';

const List<Widget> discoverScreens = [
  HomeScreen(),
  Center(child: Text('Search Page')),
  MyClassScreen(),
  ProfileScreen(),
];