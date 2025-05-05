import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widya/repository/category_repository.dart';
import 'package:widya/res/widgets/app_urls.dart';
import 'package:widya/res/widgets/logger.dart';

class CategoryViewModel with ChangeNotifier {
  final CategoryRepository _categoryRepository = CategoryRepository();

  List<dynamic> _category = []; 
  List<dynamic> get category => _category;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  final String _categoryCacheKey = 'cached_category_id_name';

  Future<void> fetchCategory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    AppLogger.logInfo("Url: ${AppUrls.getCategory}");
    try {
      final response = await _categoryRepository.fetchCategory();
      AppLogger.logInfo('📥 Category Response: $response');
      
      if (response['data'] != null) {
        _category = List.from(response['data']);
        
        final List<Map<String, dynamic>> idNameList = _category.map<Map<String, dynamic>>((cat) {
          return {
            'id': cat['id'],
            'name': cat['name'],
          };
        }).toList();

        await _cacheCategoryIdAndName(idNameList);
      } else {
        throw Exception("Failed to fetch category data");
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.logError('Error fetching categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _cacheCategoryIdAndName(List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_categoryCacheKey, jsonEncode(data));
    AppLogger.logInfo('✅ Cached category id+name: $data');
  }

  Future<List<Map<String, dynamic>>> getCachedCategoryIdAndName() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_categoryCacheKey);
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map<Map<String, dynamic>>((e) => {
        'id': e['id'],
        'name': e['name'],
      }).toList();
    }
    return [];
  }
}
