import 'package:flutter/material.dart';
import 'package:widya/models/gallery/gallery.dart';
import 'package:widya/repository/gallery_repository.dart';

class GalleryViewModel with ChangeNotifier {
  final GalleryRepository _galleryRepository = GalleryRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Gallery? _gallery;
  Gallery? get gallery => _gallery;
  
  List<GalleryList> get galleryItems => _gallery?.data ?? [];
  
  Future<void> fetchGallery() async {
    _setLoading(true);
    _error = null;
    
    try {
      final response = await _galleryRepository.fetchGallery();
      
      _gallery = Gallery.fromJson(response);
      
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _error = e.toString();
      debugPrint('Gallery fetch error: $e');
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void refreshGallery() {
    fetchGallery();
  }
  
  void resetError() {
    _error = null;
    notifyListeners();
  }
}