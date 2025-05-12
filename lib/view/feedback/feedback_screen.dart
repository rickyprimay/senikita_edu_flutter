import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:widya/res/widgets/shared_preferences.dart';
import 'package:widya/repository/feedback_repository.dart';

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
  bool _showFeedback = false;
  Map<String, dynamic>? _feedbackResponse;
  
  Future<void> _pickFile() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (image != null) {
        final fileBytes = await image.readAsBytes();
        if (fileBytes.isEmpty) {
          throw Exception('Selected file is empty');
        }

        final validExtensions = ['jpg', 'jpeg', 'png'];
        final extension = image.path.split('.').last.toLowerCase();
        if (!validExtensions.contains(extension)) {
          throw Exception('File must be a JPG or PNG image');
        }

        setState(() {
          _selectedFile = File(image.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gambar berhasil dipilih'),
            backgroundColor: AppColors.customGreen,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.customRed,
        ),
      );
      AppLogger.logError('Gallery picker error: $e');
    }
  }
  
  Future<void> _getAIFeedback() async {
    if (_selectedFile == null) return;

    setState(() {
      _loading = true;
    });

    try {
      final sp = await SharedPrefs.instance;
      final token = sp.getString('auth_token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final repository = FeedbackRepository();
      final response = await repository.submitFeedback(
        token: token,
        imageFile: _selectedFile!,
        rules: widget.rules,
      );

      AppLogger.logInfo('Feedback response: $response');

      if (response.containsKey('detail')) {
        throw Exception(response['detail'].toString());
      }

      setState(() {
        _loading = false;
        _showFeedback = true;
        _feedbackResponse = response;
      });

    } catch (e) {
      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mendapatkan feedback: ${e.toString()}'),
          backgroundColor: AppColors.customRed,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      AppLogger.logError('Feedback submission error: $e');
    }
  }
  
  int get _overallRating {
    if (_feedbackResponse != null && 
        _feedbackResponse!['data'] != null && 
        _feedbackResponse!['data']['rating'] != null) {
      return (_feedbackResponse!['data']['rating'] as num).toInt() * 10;
    }
    return 0;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.tertiary,
              ],
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tertiary.withAlpha(120),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                
                if (!_showFeedback) ...[
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
                ],
                
                const SizedBox(height: 30),
                
                if (_showFeedback && _feedbackResponse != null) ...[
                  if (!_showFeedback) const Divider(thickness: 1),
                  
                  if (_selectedFile != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedFile!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  Text(
                    'Hasil Analisis AI',
                    style: AppFont.crimsonTextHeader.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tertiary,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
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
                                  '$_overallRating/100',
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
                  
                  if (_feedbackResponse!['data']?['kesesuian_dengan_rules'] != null)
                    _buildFeedbackCard(
                      'Kesesuaian dengan Rules',
                      _feedbackResponse!['data']['kesesuian_dengan_rules'],
                      Icons.view_comfy_alt_outlined,
                      _overallRating - 5,
                    ),
                  
                  const SizedBox(height: 12),
                  
                  if (_feedbackResponse!['data']?['feedback'] != null)
                    _buildFeedbackCard(
                      'Feedback',
                      _feedbackResponse!['data']['feedback'],
                      Icons.auto_awesome_outlined,
                      _overallRating + 5,
                    ),
                  
                  const SizedBox(height: 24),
                  
                  if (_feedbackResponse!['data']?['kesimpulan'] != null)
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
                            _feedbackResponse!['data']['kesimpulan'],
                            style: AppFont.ralewaySubtitle.copyWith(
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fitur berbagi feedback akan segera hadir!')),
                        );
                      },
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
    final clampedScore = score.clamp(0, 100);
    
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
                  '$clampedScore/100',
                  style: AppFont.ralewaySubtitle.copyWith(
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
              fontWeight: FontWeight.w400,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}