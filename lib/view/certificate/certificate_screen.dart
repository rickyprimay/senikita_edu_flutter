import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/models/certificate/certificate.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/viewModel/certificate_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
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
            return _buildLoading();
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

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Memuat sertifikat...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
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
            child: const Text('Coba Lagi'),
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
          // Image.asset(
          //   'assets/images/empty_certificate.png', 
          //   width: 150,
          //   height: 150,
          //   fit: BoxFit.contain,
          //   errorBuilder: (context, error, stackTrace) => 
          //     const Icon(Icons.card_membership, size: 150, color: Colors.grey),
          // ),
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
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Certificate preview image
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: "https://eduapi.senikita.my.id/storage/${certificate.certificateImage}",
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                errorWidget: (context, url, error) => Center(
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
          
          // Certificate details
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
                
                // Certificate number
                Row(
                  children: [
                    const Icon(Icons.numbers, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'No. Sertifikat: $certNumber',
                        style: AppFont.nunitoSubtitle.copyWith(
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
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
                      style: AppFont.nunitoSubtitle.copyWith(
                        color: Colors.grey[700],
                        fontSize: 12,
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
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('Lihat'),
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
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Unduh'),
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
    final url = "https://eduapi.senikita.my.id/storage/${certificate.certificateImage}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka sertifikat')),
      );
    }
  }

  void _downloadCertificate(CertificateList certificate) async {
    final url = "https://eduapi.senikita.my.id/storage/${certificate.certificatePdf}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat mengunduh sertifikat')),
      );
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}