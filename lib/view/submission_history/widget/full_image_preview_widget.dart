import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:widya/res/widgets/fonts.dart';

class FullImagePreview extends StatelessWidget {
  final String imageUrl;

  const FullImagePreview({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Preview Karya',
          style: AppFont.crimsonTextSubtitle.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.broken_image, size: 64, color: Colors.white54),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat gambar',
                    style: AppFont.ralewaySubtitle.copyWith(color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}