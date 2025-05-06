import 'package:flutter/material.dart';

Color GetLevelColor(String level) {
  final lowerLevel = level.toLowerCase();
  if (lowerLevel == 'pemula') {
    return Colors.green.shade400;
  } else if (lowerLevel == 'menengah') {
    return Colors.amber.shade600;
  } else {
    return Colors.red.shade400;
  }
}