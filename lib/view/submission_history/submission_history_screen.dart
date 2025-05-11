import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:widya/models/submissions/submission.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/viewModel/submission_view_model.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  final int lessonId;
  const SubmissionHistoryScreen({
    required this.lessonId,
    super.key
  });

  @override
  State<SubmissionHistoryScreen> createState() => _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    
    // Call fetchSubmission automatically when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubmissionViewModel>(context, listen: false)
          .fetchSubmission(lessonId: widget.lessonId);
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return AppColors.customGreen;
      case 'rejected':
        return AppColors.customRed;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Riwayat Karya',
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
      body: Consumer<SubmissionViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading) {
            return const Center(child: Loading(opacity: 1.0));
          }
          
          if (viewModel.error != null) {
            return _buildErrorView(viewModel.error!);
          }
          
          if (viewModel.submission == null || viewModel.submission!.data.isEmpty) {
            return _buildEmptyView();
          }
          
          return _buildSubmissionList(viewModel.submission!);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.pushNamed(
            context, 
            '/submission',
            arguments: {'lessonId': widget.lessonId}
          ).then((_) {
            // Refresh the list when returning from submission screen
            Provider.of<SubmissionViewModel>(context, listen: false)
                .fetchSubmission(lessonId: widget.lessonId);
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.customRed),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat riwayat karya',
              style: AppFont.crimsonTextSubtitle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: AppFont.ralewaySubtitle.copyWith(
                color: Colors.grey[700],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Provider.of<SubmissionViewModel>(context, listen: false)
                    .fetchSubmission(lessonId: widget.lessonId);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.art_track, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Belum ada karya yang dikirimkan',
            style: AppFont.crimsonTextSubtitle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Mulailah berkarya dan kirimkan karya pertamamu',
              style: AppFont.ralewaySubtitle.copyWith(
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context, 
                '/submission',
                arguments: {'lessonId': widget.lessonId}
              ).then((_) {
                Provider.of<SubmissionViewModel>(context, listen: false)
                    .fetchSubmission(lessonId: widget.lessonId);
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Kirim Karya'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionList(Submission submission) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<SubmissionViewModel>(context, listen: false)
            .fetchSubmission(lessonId: widget.lessonId);
      },
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: submission.data.length,
        itemBuilder: (context, index) {
          final item = submission.data[index];
          return _buildSubmissionCard(item);
        },
      ),
    );
  }

  Widget _buildSubmissionCard(Datum submission) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image preview with status badge overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Image.network(
                    submission.filePath ?? "",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.withOpacity(0.1),
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.withOpacity(0.1),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(submission.status ?? "").withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    submission.status ?? "Status Tidak Diketahui",
                    style: AppFont.ralewaySubtitle.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (submission.isPublished == 1)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.public, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'Publik',
                          style: AppFont.ralewaySubtitle.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  submission.submission ?? "Karya Tanpa Judul",
                  style: AppFont.crimsonTextSubtitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // Date
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(submission.createdAt ?? DateTime.now()),
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Feedback section if available
                if (submission.feedback != null && submission.feedback.toString().isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Feedback Pengajar:',
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          submission.feedback.toString(),
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                // Score if available
                if (submission.score != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Text(
                          'Nilai:',
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                          ),
                          child: Text(
                            submission.score.toString(),
                            style: AppFont.crimsonTextSubtitle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Actions section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Open full image preview
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _FullImagePreview(imageUrl: submission.filePath ?? ""),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Lihat Gambar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget for image preview
class _FullImagePreview extends StatelessWidget {
  final String imageUrl;

  const _FullImagePreview({required this.imageUrl});

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