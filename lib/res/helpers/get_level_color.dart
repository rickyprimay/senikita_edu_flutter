import 'package:flutter/material.dart';
import 'package:widya/res/widgets/colors.dart';

Color getLevelColor(String level) {
  final lowerLevel = level.toLowerCase();
  if (lowerLevel == 'pemula') {
    return AppColors.customGreen;
  } else if (lowerLevel == 'menengah') {
    return AppColors.tertiary;
  } else {
    return AppColors.brick;
  }
}