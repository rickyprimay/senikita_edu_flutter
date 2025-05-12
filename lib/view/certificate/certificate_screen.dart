import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/models/certificate/certificate.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/viewModel/certificate_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final _flutterMediaDownloaderPlugin = MediaDownload();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CertificateViewModel>(context, listen: false).fetchCertificate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Sertifikat Saya',
          style: AppFont.crimsonTextHeader.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<CertificateViewModel>(
        builder: (context, certificateViewModel, _) {
          if (certificateViewModel.loading) {
            return Loading(opacity: 0.8);
          }
          
          if (certificateViewModel.error != null) {
            return _buildError(certificateViewModel.error!);
          }
          
          if (certificateViewModel.certificate == null ||
              certificateViewModel.certificate!.data.isEmpty) {
            return _buildEmptyCertificates();
          }
          
          return _buildCertificateList(certificateViewModel.certificate!);
        },
      ),
    );
  }

  Widget _buildError(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Provider.of<CertificateViewModel>(context, listen: false)
                  .fetchCertificate();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Coba Lagi',
              style: AppFont.ralewaySubtitle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCertificates() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Text(
            'Belum ada sertifikat',
            style: AppFont.crimsonTextHeader.copyWith(
              fontSize: 20,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Selesaikan kursus untuk mendapatkan sertifikat keahlian',
              textAlign: TextAlign.center,
              style: AppFont.ralewaySubtitle.copyWith(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Jelajahi Kursus',
              style: AppFont.ralewaySubtitle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateList(Certificate certificate) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: certificate.data.length,
      itemBuilder: (context, index) {
        final cert = certificate.data[index];
        return _buildCertificateCard(cert);
      },
    );
  }

  Widget _buildCertificateCard(CertificateList certificate) {
    final courseTitle = certificate.enrollment.course.title;
    final certNumber = certificate.certificateNumber;
    final completedDate = _formatDate(certificate.enrollment.completedAt);
    
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                certificate.certificateImage,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Loading(opacity: 0.8);
                },
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'Preview tidak tersedia',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseTitle,
                  style: AppFont.crimsonTextFootnoteSmall.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    const Icon(Icons.numbers, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            'No. Sertifikat: ',
                            style: AppFont.ralewaySubtitle.copyWith(
                              color: Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            certNumber,
                            style: AppFont.nunitoSubtitle.copyWith(
                              color: Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Completion date
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      'Selesai pada $completedDate',
                      style: AppFont.ralewaySubtitle.copyWith(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _openCertificatePreview(certificate),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.visibility, size: 16, color: AppColors.secondary),
                        label: Text(
                          'Lihat',
                          style: AppFont.ralewaySubtitle.copyWith(
                            color: AppColors.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _downloadCertificate(certificate),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.download, size: 16, color: Colors.white),
                        label: Text(
                          'Unduh',
                          style: AppFont.ralewaySubtitle.copyWith(
                            color: Colors.white,
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
          ),
        ],
      ),
    );
  }

  void _openCertificatePreview(CertificateList certificate) async {
    final url = certificate.certificateImage;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka sertifikat')),
      );
    }
  }

  void _downloadCertificate(CertificateList certificate) async {
  final url = certificate.certificatePdf;
  
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
                'Unduh Sertifikat',
                textAlign: TextAlign.center,
                style: AppFont.crimsonTextHeader.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.download_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Unduh Sertifikat',
                style: AppFont.ralewaySubtitle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Apakah Anda yakin ingin mengunduh sertifikat ini ke perangkat Anda?',
                style: AppFont.ralewaySubtitle.copyWith(
                  fontSize: 14,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Tidak",
                        style: AppFont.ralewaySubtitle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                        
                        try {
                          await _flutterMediaDownloaderPlugin.downloadMedia(
                            context,
                            url,
                          );
                        } catch (e) {
                          // TODOS
                        }
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
                        "Ya, Unduh",
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

  String _formatDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}