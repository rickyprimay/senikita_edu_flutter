import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/repository/temu_batik_repository.dart';

class TemuBatikScreen extends StatefulWidget {
  const TemuBatikScreen({super.key});

  @override
  State<TemuBatikScreen> createState() => _TemuBatikScreenState();
}

class _TemuBatikScreenState extends State<TemuBatikScreen> {
  File? _selectedFile;
  bool _loading = false;
  bool _showResult = false;
  Map<String, dynamic>? _temuBatikResponse;
  String _selectedTheme = 'cendrawasih';
  
  final List<String> _batikThemes = [
    'cendrawasih', 'tambal', 'sogan', 'sidomukti', 
    'sidoluhur', 'sekar', 'priangan', 'pekalongan', 
    'parang', 'megamendung', 'lasem', 'keraton', 
    'kawung', 'gentongan', 'garutan', 'ciamis', 
    'ceplok', 'celup', 'betawi', 'bali'
  ];
  
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
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.customRed,
        ),
      );
    }
  }
  
  Future<void> _submitTemuBatik() async {
    if (_selectedFile == null) return;

    setState(() {
      _loading = true;
    });

    try {
      final repository = TemuBatikRepository();
      final response = await repository.submitTemuBatik(
        file: _selectedFile!,
        tema: _selectedTheme,
      );

      if (response.containsKey('detail') || response['success'] == false) {
        throw Exception(response['detail']?.toString() ?? 'Unknown error occurred');
      }

      setState(() {
        _loading = false;
        _showResult = true;
        _temuBatikResponse = response;
      });

    } catch (e) {
      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim gambar: ${e.toString()}'),
          backgroundColor: AppColors.customRed,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }
  
  double get _similarityScore {
    if (_temuBatikResponse != null && 
        _temuBatikResponse!['data'] != null && 
        _temuBatikResponse!['data']['similiarity_score'] != null) {
      return (_temuBatikResponse!['data']['similiarity_score'] as num).toDouble() * 100;
    }
    return 0;
  }
  
  Future<void> _refreshScreen() async {
    setState(() {
      _selectedFile = null;
      _showResult = false;
      _temuBatikResponse = null;
    });
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
        title: Text(
          'Temu Batik',
          style: AppFont.crimsonTextHeader.copyWith(
            fontSize: 20,
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
      body: LiquidPullToRefresh(
        onRefresh: _refreshScreen,
        showChildOpacityTransition: true,
        color: AppColors.primary,
        height: 60,
        backgroundColor: Colors.white,
        animSpeedFactor: 2,
        child: Stack(
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
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        colors: [
                          AppColors.tertiary.withOpacity(0.9), 
                          AppColors.primary.withOpacity(0.8)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.auto_awesome_outlined, color: Colors.white, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'Temu Batik',
                          style: AppFont.crimsonTextHeader.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Unggah gambar batik dan pilih tema untuk mengenal motif batik',
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  if (!_showResult) ...[
                    Text(
                      'Upload Gambar Batik',
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
                        fontWeight: FontWeight.w400,
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
                                    label: Text(
                                      'Ganti Gambar',
                                      style: AppFont.ralewaySubtitle.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.tertiary,
                                      ),
                                    ),
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
                    
                    const SizedBox(height: 24),
                    
                    Text(
                      'Pilih Tema Batik',
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedTheme,
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: AppFont.ralewaySubtitle.copyWith(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          isExpanded: true,
                          onChanged: (String? value) {
                            if (value != null) {
                              setState(() {
                                _selectedTheme = value;
                              });
                            }
                          },
                          items: _batikThemes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value[0].toUpperCase() + value.substring(1),
                                style: AppFont.ralewaySubtitle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _selectedFile != null && !_loading ? _submitTemuBatik : null,
                        icon: const Icon(Icons.search),
                        label: Text(
                          'Analisis Gambar Batik',
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
                  
                  if (_showResult && _temuBatikResponse != null) ...[
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
                      'Hasil Analisis Batik',
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
                                  Icons.percent,
                                  color: AppColors.tertiary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Skor Kemiripan',
                                      style: AppFont.ralewaySubtitle.copyWith(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_similarityScore.toStringAsFixed(1)}%',
                                      style: AppFont.crimsonTextHeader.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.tertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _similarityScore > 70 
                                      ? AppColors.customGreen.withOpacity(0.2)
                                      : AppColors.customRed.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _similarityScore > 70 ? 'Cocok' : 'Tidak Cocok',
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: _similarityScore > 70 
                                        ? AppColors.customGreen 
                                        : AppColors.customRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    if (_temuBatikResponse!['data']?['tema'] != null)
                      _buildResultCard(
                        'Kesesuaian Tema',
                        _temuBatikResponse!['data']['tema'],
                        Icons.category,
                      ),
                    
                    const SizedBox(height: 12),
                    
                    if (_temuBatikResponse!['data']?['keunikan_motif'] != null)
                      _buildResultCard(
                        'Keunikan Motif',
                        _temuBatikResponse!['data']['keunikan_motif'],
                        Icons.auto_awesome,
                      ),
                    
                    const SizedBox(height: 12),
                    
                    if (_temuBatikResponse!['data']?['teknik_pewarnaan_dan_komposisi'] != null)
                      _buildResultCard(
                        'Teknik Pewarnaan & Komposisi',
                        _temuBatikResponse!['data']['teknik_pewarnaan_dan_komposisi'],
                        Icons.palette,
                      ),
                    
                    const SizedBox(height: 24),
                    
                    if (_temuBatikResponse!['data']?['kesimpulan'] != null)
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
                            Row(
                              children: [
                                const Icon(Icons.summarize, color: AppColors.tertiary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Kesimpulan',
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _temuBatikResponse!['data']['kesimpulan'],
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
                        onPressed: _refreshScreen,
                        icon: const Icon(Icons.refresh),
                        label: Text(
                          'Analisis Gambar Lain',
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
      ),
    );
  }

  Widget _buildResultCard(String title, String description, IconData iconData) {
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