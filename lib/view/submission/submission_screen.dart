import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:widya/viewModel/submission_view_model.dart';

class SubmissionScreen extends StatefulWidget {
  final int lessonId;
  final String? lessonTitle;
  final String submissionType;

  const SubmissionScreen({
    super.key, 
    required this.lessonId,
    required this.submissionType,
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
      _fileError = null; 
    });
    
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
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
      
      _showErrorDialog('Terjadi masalah saat membuka galeri. Pastikan aplikasi memiliki izin akses.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          children: [
            Column(
              children: [
                Text(
                  'Berhasil! 🎉', 
                  style: AppFont.crimsonTextSubtitle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.customGreen, 
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.customGreen.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.customGreen,
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: AppColors.customGreen,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Karya kamu berhasil dikirim!',
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Karya kamu sedang diproses dan akan segera diperiksa.',
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Kembali ke Kelas',
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          children: [
            Column(
              children: [
                Text(
                  'Gagal! 😕', 
                  style: AppFont.crimsonTextSubtitle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.customRed, 
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.customRed.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.customRed,
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: AppColors.customRed,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Terjadi kesalahan',
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          side: BorderSide(color: AppColors.secondary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Coba Lagi',
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Kembali',
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (widget.submissionType == "file" && _selectedFile == null) {
      setState(() {
        _fileError = 'Silahkan pilih gambar terlebih dahulu';
      });
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = Provider.of<SubmissionViewModel>(context, listen: false);

    try {
      if (widget.submissionType == "file") {
        await viewModel.submitSubmission(
          lessonId: widget.lessonId,
          submissionText: _titleController.text,
          filePath: _selectedFile!.path,
          isPublished: _isPublic ? 1 : 0,
          context: context,
        );
      } else {
        await viewModel.submitLinkSubmission(
          lessonId: widget.lessonId,
          submissionText: _titleController.text,
          isPublished: _isPublic ? 1 : 0,
          context: context,
        );
      }

      if (viewModel.error != null) {
        if (mounted) {
          _showErrorDialog(viewModel.error!);
        }
      } else {
        if (mounted) {
          _showSuccessDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog("Terjadi kesalahan: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubmissionViewModel>(
      builder: (context, viewModel, child) {
        return Stack(
          children: [
            Scaffold(
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
                title: Text(
                  'Submit Karya',
                  style: AppFont.crimsonTextSubtitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
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
                          
                        // const SizedBox(height: 24),

                        (widget.submissionType != "file")
                        ?  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Link Youtube',
                                style: AppFont.ralewaySubtitle.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            const SizedBox(height: 8),
                            TextFormField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  hintText: 'Masukkan Link Youtube',
                                  hintStyle: AppFont.ralewaySubtitle.copyWith(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
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
                              ],
                            )
                          : const SizedBox.shrink(),
                        
                        // const SizedBox(height: 20),
                        
                        (widget.submissionType == "file")
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload Gambar Karya',
                              style: AppFont.ralewaySubtitle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Format: JPG, PNG (Maks. 10MB)',
                              style: AppFont.ralewaySubtitle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
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
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
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
                          ],
                        )
                        : const SizedBox.shrink(),
                        
                        const SizedBox(height: 24),
                        
                        // Public option toggle
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isPublic 
                                  ? AppColors.primary.withOpacity(0.5)
                                  : Colors.grey.withOpacity(0.3),
                            ),
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
                                        color: _isPublic ? AppColors.primary : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Izinkan karya kamu dilihat oleh pengguna lain',
                                      style: AppFont.ralewaySubtitle.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
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
                                activeTrackColor: AppColors.primary.withOpacity(0.2),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: viewModel.loading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: Colors.grey.withOpacity(0.5),
                            ),
                            child: Text(
                              viewModel.loading ? 'Mengirim...' : 'Submit Karya',
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
            if (viewModel.loading) const Loading(opacity: 0.7),
          ],
        );
      },
    );
  }
}