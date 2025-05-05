import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  String _selectedLabel = "Semua";

  String get selectedLabel => _selectedLabel;

  void selectCategory(String label) {
    _selectedLabel = label;
    notifyListeners();
  }
}
