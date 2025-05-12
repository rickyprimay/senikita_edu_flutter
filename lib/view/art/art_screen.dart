import 'package:flutter/material.dart';
import 'package:flutter_lightbox/image_type.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:widya/models/gallery/gallery.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:flutter_lightbox/flutter_lightbox.dart';
import 'package:widya/viewModel/gallery_view_model.dart';

class ArtScreen extends StatefulWidget {
  const ArtScreen({super.key});

  @override
  State<ArtScreen> createState() => _ArtScreenState();
}

class _ArtScreenState extends State<ArtScreen> {
  final ScrollController _scrollController = ScrollController();
  
  int _itemsPerPage = 10;
  int _currentPage = 0;
  List<GalleryList> _displayedItems = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GalleryViewModel>(context, listen: false).fetchGallery();
    });
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.7) {
        _loadMoreItems();
      }
    });
  }

  void _loadMoreItems() {
    if (_isLoadingMore) return;
    
    final viewModel = Provider.of<GalleryViewModel>(context, listen: false);
    final allItems = viewModel.galleryItems;
    
    if (_displayedItems.length >= allItems.length) return;
    
    setState(() {
      _isLoadingMore = true;
    });
    
    Future.delayed(const Duration(milliseconds: 300), () {
      final startIndex = _displayedItems.length;
      
      if (startIndex < allItems.length) {
        final itemsToAdd = allItems
            .skip(startIndex)
            .take(_itemsPerPage)
            .toList();
        
        if (mounted) {
          setState(() {
            _displayedItems.addAll(itemsToAdd);
            _currentPage++;
            _isLoadingMore = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      }
    });
  }

  void _showLightbox(int initialIndex) {
    final item = _displayedItems[initialIndex];
    
    final imageUrls = _displayedItems
        .where((item) => item.filePath.isNotEmpty)
        .map((item) => item.filePath)
        .toList();

    final baseUrl = item.filePath;
    final adjustedIndex = imageUrls.indexOf(baseUrl);

    if (adjustedIndex < 0) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Lightbox",
      pageBuilder: (_, animation, secondaryAnimation) {
        return LightBox(
          initialIndex: adjustedIndex,
          images: imageUrls,
          imageType: ImageType.network,
          thumbnailHeight: 0.0,
          thumbnailWidth: 0.0,
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.tertiary,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0)),
                image: const DecorationImage(
                  image: AssetImage('assets/common/hero-texture2.png'),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
              child: Center(
                child: Text(
                  'Hasil Karya Seni',
                  style: AppFont.crimsonTextSubtitle.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Expanded(
                      child: Consumer<GalleryViewModel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.isLoading && _displayedItems.isEmpty) {
                            return const Center(
                              child: Loading(opacity: 1),
                            );
                          }
                          
                          if (viewModel.error != null && _displayedItems.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    size: 60,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Gagal memuat karya',
                                    style: AppFont.crimsonTextSubtitle.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    viewModel.error!,
                                    textAlign: TextAlign.center,
                                    style: AppFont.ralewaySubtitle.copyWith(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      viewModel.fetchGallery();
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Coba Lagi'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          
                          if (viewModel.galleryItems.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 60,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Belum ada karya',
                                    style: AppFont.crimsonTextSubtitle.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32),
                                    child: Text(
                                      'Saat ini belum ada karya yang dipublikasikan',
                                      textAlign: TextAlign.center,
                                      style: AppFont.ralewaySubtitle.copyWith(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          
                          if (_displayedItems.isEmpty && viewModel.galleryItems.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _loadMoreItems();
                            });
                          }
                          
                          return MasonryGridView.count(
                            controller: _scrollController,
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            itemCount: _displayedItems.length + (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _displayedItems.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final item = _displayedItems[index];
                              final imageUrl = item.filePath;

                              return GestureDetector(
                                onTap: () => _showLightbox(index),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        placeholder: (context, url) => AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.1),
                                                Colors.black.withOpacity(0.5),
                                                Colors.black.withOpacity(0.7),
                                              ],
                                              stops: const [0.0, 0.6, 0.75, 0.85, 1.0],
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      Positioned(
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.user.name,
                                              style: AppFont.ralewaySubtitle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 3.0,
                                                    color: Colors.black.withOpacity(0.5),
                                                    offset: const Offset(1, 1),
                                                  ),
                                                ],
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}