import 'package:flutter/material.dart';
import 'package:flutter_lightbox/image_type.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:flutter_lightbox/flutter_lightbox.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ArtScreen extends StatefulWidget {
  const ArtScreen({super.key});

  @override
  State<ArtScreen> createState() => _ArtScreenState();
}

class _ArtScreenState extends State<ArtScreen> {
  static const List<String> imageUrls = [
    'https://placehold.co/400x600/png',
    'https://youtu.be/HrFc7W7MxzE?si=1J8ixpgzkfx--cG5',
    'https://placehold.co/400x500/png',
    'https://placehold.co/400x700/png',
    'https://youtu.be/HrFc7W7MxzE?si=1J8ixpgzkfx--cG5',
    'https://placehold.co/400x300/png',
    'https://placehold.co/400x800/png',
    'https://placehold.co/400x400/png',
    'https://placehold.co/400x550/png',
    'https://placehold.co/400x650/png',
  ];

  final Map<String, String?> _videoIdCache = {};
  
  final ScrollController _scrollController = ScrollController();
  
  int _itemsPerPage = 4;
  int _currentPage = 0;
  List<String> _displayedItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    _loadMoreItems();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.7) {
        _loadMoreItems();
      }
    });
  }

  void _loadMoreItems() {
    if (_isLoading) return;
    
    
    setState(() {
      _isLoading = true;
    });
    
    Future.delayed(const Duration(milliseconds: 300), () {
      final startIndex = _displayedItems.length;
      
      AppLogger.logInfo("Start index: $startIndex, imageUrls length: ${imageUrls.length}");
      
      if (startIndex < imageUrls.length) {
        final itemsToAdd = imageUrls.skip(startIndex).take(_itemsPerPage).toList();
        
        AppLogger.logInfo("Adding ${itemsToAdd.length} new items");
        
        if (mounted) {
          setState(() {
            _displayedItems.addAll(itemsToAdd);
            _currentPage++;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  String? getVideoId(String url) {
    if (_videoIdCache.containsKey(url)) {
      return _videoIdCache[url];
    }
    
    final videoId = YoutubePlayer.convertUrlToId(url);
    _videoIdCache[url] = videoId;
    return videoId;
  }

  bool isYoutubeLink(String url) {
    return url.contains("youtube.com") || url.contains("youtu.be");
  }

  void _showLightbox(int initialIndex) {
    final url = _displayedItems[initialIndex];

    if (isYoutubeLink(url)) {
      final videoId = getVideoId(url);
      if (videoId == null) return;

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Lightbox",
        pageBuilder: (_, animation, secondaryAnimation) {
          return Center(
            child: Container(
              color: Colors.black.withOpacity(0.9),
              padding: const EdgeInsets.all(20),
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: const YoutubePlayerFlags(
                    autoPlay: true,
                    mute: false,
                  ),
                ),
                showVideoProgressIndicator: true,
                width: double.infinity,
              ),
            ),
          );
        },
      );
    } else {
      final imageUrls = _displayedItems.where((url) => !isYoutubeLink(url)).toList();
      final adjustedIndex = imageUrls.indexOf(url);

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
                      child: MasonryGridView.count(
                        controller: _scrollController,
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        itemCount: _displayedItems.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _displayedItems.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final url = _displayedItems[index];

                          if (isYoutubeLink(url)) {
                            final videoId = getVideoId(url);
                            if (videoId == null) {
                              return const SizedBox.shrink();
                            }

                            return GestureDetector(
                              onTap: () => _showLightbox(index),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: 'https://img.youtube.com/vi/$videoId/0.jpg',
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.error),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () => _showLightbox(index),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: url,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            );
                          }
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