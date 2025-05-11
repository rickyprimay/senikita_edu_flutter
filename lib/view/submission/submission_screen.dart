import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';

class SubmissionScreen extends StatefulWidget {
  final int lessonId;
  final String? lessonTitle;

  const SubmissionScreen({
    super.key, 
    required this.lessonId,
    this.lessonTitle,
  });

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPublic = false;
  bool _isLoading = false;
  File? _selectedFile;
  String? _fileError;
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
  setState(() {
    _fileError = null; // Clear previous errors
  });
  
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Adjust quality as needed (80% is good for most cases)
    );
    
    if (image != null) {
      setState(() {
        _selectedFile = File(image.path);
        _fileError = null;
      });
    }
  } catch (e) {
    setState(() {
      _fileError = 'Gagal membuka galeri: ${e.toString()}';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Terjadi masalah saat membuka galeri. Pastikan aplikasi memiliki izin akses.'
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 5),
      )
    );
    
    print('Gallery picker error: $e');
  }
}
  
  String _getFileSize() {
    if (_selectedFile == null) return '';
    
    final bytes = _selectedFile!.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  Future<void> _submitForm() async {
    if (_selectedFile == null) {
      setState(() {
        _fileError = 'Silahkan pilih gambar terlebih dahulu';
      });
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call with delay
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Submission uploaded successfully!'),
            backgroundColor: AppColors.customGreen,
          ),
        );
        
        // Navigate back
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.customRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Text(
              'Submit Karya',
              style: AppFont.crimsonTextSubtitle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lesson info card
                    if (widget.lessonTitle != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Submission untuk:',
                              style: AppFont.ralewaySubtitle.copyWith(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.lessonTitle!,
                              style: AppFont.crimsonTextSubtitle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                    const SizedBox(height: 24),
                      
                    // Title field
                    Text(
                      'Judul Karya',
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan judul karya',
                        hintStyle: AppFont.ralewaySubtitle.copyWith(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Judul tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                  
                    Text(
                      'Upload Gambar Karya', 
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
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
                                ? AppColors.primary
                                : Colors.grey.withOpacity(0.5),
                            width: _selectedFile != null ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _selectedFile != null
                                  ? Icons.check_circle_outline
                                  : Icons.upload_file,
                              size: 48,
                              color: _selectedFile != null
                                  ? AppColors.primary
                                  : Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _selectedFile != null
                                  ? _selectedFile!.path.split('/').last
                                  : 'Klik untuk memilih file',
                              style: AppFont.ralewaySubtitle.copyWith(
                                fontWeight: _selectedFile != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: _selectedFile != null
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_selectedFile != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                _getFileSize(),
                                style: AppFont.ralewaySubtitle.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: _pickFile,
                                icon: const Icon(Icons.refresh, size: 16),
                                label: const Text('Ganti File'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                ),
                              )
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    if (_fileError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _fileError!,
                          style: AppFont.ralewaySubtitle.copyWith(
                            color: AppColors.customRed,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Public option
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Publikasikan Karya',
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Ijinkan karya kamu dilihat oleh pengguna lain',
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isPublic,
                            onChanged: (value) {
                              setState(() {
                                _isPublic = value;
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Submit Karya',
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading) const Loading(opacity: 0.7),
      ],
    );
  }
}