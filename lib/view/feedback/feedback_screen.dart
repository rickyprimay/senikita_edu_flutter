import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';

class FeedbackScreen extends StatefulWidget {
  final int lessonId;
  final String rules;

  const FeedbackScreen({
    required this.lessonId,
    required this.rules,
    super.key
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  File? _selectedFile;
  bool _loading = false;
  bool _showFeedback = false; // To toggle feedback display for demo purposes
  
  Future<void> _pickFile() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedFile = File(image.path);
        });
      }
    } catch (e) {
      // Handle errors
    }
  }
  
  void _getAIFeedback() {
    if (_selectedFile == null) return;
    
    setState(() {
      _loading = true;
    });
    
    // Simulate loading for demo
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
        _showFeedback = true;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.tertiary.withOpacity(0.9), 
                        AppColors.primary.withOpacity(0.8)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'AI Feedback',
                        style: AppFont.crimsonTextHeader.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Unggah karya kamu dan dapatkan feedback dari AI',
                        style: AppFont.ralewaySubtitle.copyWith(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Image upload section
                Text(
                  'Upload Karya',
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Format: JPG, PNG (Maks. 10MB)',
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                
                InkWell(
                  onTap: _pickFile,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedFile != null
                            ? AppColors.tertiary
                            : Colors.grey.withOpacity(0.5),
                        width: _selectedFile != null ? 2 : 1,
                      ),
                    ),
                    child: _selectedFile != null
                        ? Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedFile!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: _pickFile,
                                icon: const Icon(Icons.refresh, size: 16),
                                label: const Text('Ganti Gambar'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.tertiary,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.upload_file,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Klik untuk memilih gambar',
                                style: AppFont.ralewaySubtitle.copyWith(
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _selectedFile != null && !_loading ? _getAIFeedback : null,
                    icon: const Icon(Icons.smart_toy_outlined),
                    label: Text(
                      'Dapatkan Feedback AI',
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tertiary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // AI Feedback results section
                if (_showFeedback) ...[
                  const Divider(thickness: 1),
                  const SizedBox(height: 20),
                  
                  Text(
                    'Hasil Analisis AI',
                    style: AppFont.crimsonTextHeader.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tertiary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Overall score card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.tertiary.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.tertiary.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.star,
                                color: AppColors.tertiary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nilai Keseluruhan',
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '85/100',
                                  style: AppFont.crimsonTextHeader.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.tertiary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Detailed feedback
                  _buildFeedbackCard(
                    'Komposisi',
                    'Komposisi karya sangat baik dengan keseimbangan yang tepat antara objek utama dan latar belakang. Penempatan objek di tengah frame memberikan fokus yang jelas.',
                    Icons.view_comfy_alt_outlined,
                    90
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildFeedbackCard(
                    'Teknik Pewarnaan',
                    'Teknik pewarnaan cukup baik, namun masih perlu memperhatikan gradasi warna pada beberapa bagian. Kombinasi warna kontras sudah tepat dan memberikan kesan dinamis.',
                    Icons.palette_outlined,
                    80
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildFeedbackCard(
                    'Keaslian Motif',
                    'Motif yang digunakan memiliki keunikan dan keaslian yang tinggi. Terlihat adanya eksplorasi pada pola tradisional yang dipadukan dengan elemen modern.',
                    Icons.auto_awesome_outlined,
                    85
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Overall feedback
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kesimpulan',
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Karya ini menunjukkan pemahaman yang baik tentang teknik dasar. Kekuatan utama terletak pada komposisi dan keaslian motif. Untuk pengembangan selanjutnya, perhatikan teknik pewarnaan terutama pada bagian gradasi dan transisi antar warna. Secara keseluruhan, karya ini menunjukkan potensi yang sangat baik dalam penguasaan teknik dan kreativitas.',
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Share button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined),
                      label: Text(
                        'Bagikan Feedback',
                        style: AppFont.ralewaySubtitle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.tertiary,
                        side: const BorderSide(color: AppColors.tertiary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ],
            ),
          ),
          
          if (_loading)
            const Loading(opacity: 0.9)
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(String title, String description, IconData iconData, int score) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(iconData, color: AppColors.tertiary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: AppFont.ralewaySubtitle.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$score/100',
                  style: AppFont.crimsonTextSubtitle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.tertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppFont.ralewaySubtitle.copyWith(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}