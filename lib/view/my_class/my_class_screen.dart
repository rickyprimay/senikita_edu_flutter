import 'package:flutter/material.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

class MyClassScreen extends StatefulWidget {
  const MyClassScreen({super.key});

  @override
  State<MyClassScreen> createState() => _MyClassScreenState();
}

class _MyClassScreenState extends State<MyClassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header Section
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                image: const DecorationImage(
                  image: AssetImage('assets/common/hero-texture2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Kelas Saya',
                      style: AppFont.crimsonTitleMedium.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Section
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _courseCard(
                        imagePath: 'assets/placeholder/placeholder_120x120.png',
                        title: 'Mencanting Batik',
                        subtitle: 'Ibu Siti, Pengrajin Batik',
                        progress: 0.11,
                      ),
                      const SizedBox(height: 16),
                      _courseCard(
                        imagePath: 'assets/placeholder/placeholder_120x120.png',
                        title: 'Menari Jaipong',
                        subtitle: 'Bapak Joko, Penari Jaipong',
                        progress: 0.22,
                      ),
                      const SizedBox(height: 16),
                      _courseCard(
                        imagePath: 'assets/placeholder/placeholder_120x120.png',
                        title: 'Menari Jaipong',
                        subtitle: 'Bapak Joko, Penari Jaipong',
                        progress: 0.22,
                      ),
                      const SizedBox(height: 16),
                      _courseCard(
                        imagePath: 'assets/placeholder/placeholder_120x120.png',
                        title: 'Menari Jaipong',
                        subtitle: 'Bapak Joko, Penari Jaipong',
                        progress: 0.22,
                      ),
                      const SizedBox(height: 16),
                      _courseCard(
                        imagePath: 'assets/placeholder/placeholder_120x120.png',
                        title: 'Menari Jaipong',
                        subtitle: 'Bapak Joko, Penari Jaipong',
                        progress: 0.22,
                      ),
                      const SizedBox(height: 16),
                      _courseCard(
                        imagePath: 'assets/placeholder/placeholder_120x120.png',
                        title: 'Menari Jaipong',
                        subtitle: 'Bapak Joko, Penari Jaipong',
                        progress: 0.22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _courseCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required double progress,
  }) {
    final percentage = (progress * 100).toStringAsFixed(0);
  
    return ConstrainedBox(
    constraints: BoxConstraints(maxHeight: 122),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(120),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFont.ralewayHeaderMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: AppFont.nunitoHeaderMedium.copyWith(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress,
                    color: AppColors.tertiary,
                    backgroundColor: Colors.grey[200],
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$percentage% Selesai",
                    style: AppFont.nunitoSubtitle.copyWith(
                      fontSize: 14,
                      color: Colors.black.withAlpha(120),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
    );
  }
}
