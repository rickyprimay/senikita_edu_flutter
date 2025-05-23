import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:widya/models/submissions/submission.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/view/submission_history/widget/full_image_preview_widget.dart';
import 'package:widya/res/widgets/video_player_screen.dart';
import 'package:widya/viewModel/submission_view_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  final int lessonId;
  final String lessonName;
  final String submissionType;

  const SubmissionHistoryScreen({
    required this.lessonId,
    required this.lessonName,
    required this.submissionType,
    super.key
  });

  @override
  State<SubmissionHistoryScreen> createState() => _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  @override
  void initState() {
    super.initState();
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
        return AppColors.lightBrick;
      case 'approved':
        return AppColors.customGreen;
      case 'rejected':
        return AppColors.customRed;
      default:
        return Colors.grey;
    }
  }

  String? _getYoutubeVideoId(String videoUrl) {
    return YoutubePlayer.convertUrlToId(videoUrl);
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
          'Riwayat Submission',
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
      body: Consumer<SubmissionViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading) {
            return const Center(child: Loading(opacity: 1));
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
    return LiquidPullToRefresh(
      onRefresh: () async {
        await Provider.of<SubmissionViewModel>(context, listen: false)
            .fetchSubmission(lessonId: widget.lessonId);
      },
      showChildOpacityTransition: true,
      color: AppColors.primary,
      height: 60,
      backgroundColor: Colors.white,
      animSpeedFactor: 2,
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
    final courseTitle = widget.lessonName;
    final completedDate = _formatDate(
      (submission.createdAt ?? DateTime.now()).add(const Duration(hours: 7)),
    );
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMediaSection(submission),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseTitle,
                  style: AppFont.crimsonTextSubtitle.copyWith(
                    fontSize: 18,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),
                
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      completedDate,
                      style: AppFont.nunitoSubtitle.copyWith(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
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
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                if (submission.score != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Text(
                          'Nilai:',
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
                            style: AppFont.nunitoSubtitle.copyWith(
                              fontSize: 14,
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
          
          // Add action buttons based on submission type
          _buildActionSection(submission),
        ],
      ),
    );
  }

  Widget _buildMediaSection(Datum submission) {
    // Check submission type and render appropriate media
    if (widget.submissionType != "file" && submission.submission != null) {
      // For YouTube links, show thumbnail instead of player
      try {
        final videoId = _getYoutubeVideoId(submission.submission!);
        if (videoId == null) {
          return _buildErrorMediaDisplay('Invalid YouTube URL');
        }
        
        // Use YouTube thumbnail
        final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
        
        return Stack(
          children: [
            // YouTube thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Image.network(
                  thumbnailUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(
                        child: Icon(Icons.video_library, size: 40, color: Colors.grey),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Play button overlay
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _openVideoPlayer(submission.submission!);
                  },
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Status indicator
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(submission.status ?? "").withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  (submission.status ?? "").isNotEmpty
                  ? "${(submission.status ?? "").substring(0, 1).toUpperCase()}${(submission.status ?? "").substring(1)}"
                  : "",
                  style: AppFont.ralewaySubtitle.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Public indicator
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
        );
      } catch (e) {
        return _buildErrorMediaDisplay('Invalid YouTube URL');
      }
    } else {
      // Show image for file submissions
      return Stack(
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
          
          // Status indicator
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(submission.status ?? "").withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                (submission.status ?? "").isNotEmpty
                ? "${(submission.status ?? "").substring(0, 1).toUpperCase()}${(submission.status ?? "").substring(1)}"
                : "",
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
      );
    }
  }

  void _openVideoPlayer(String videoUrl) {
    final videoId = _getYoutubeVideoId(videoUrl);
    if (videoId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            videoId: videoId,
            videoTitle: widget.lessonName,
          ),
        ),
      );
    }
  }

  Widget _buildErrorMediaDisplay(String message) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(Datum submission) {
    if (widget.submissionType == "file") {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: OutlinedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullImagePreview(
                  imageUrl: submission.filePath ?? ""
                ),
              ),
            );
          },
          icon: const Icon(Icons.visibility, size: 16),
          label: Text(
            'Lihat Gambar',
            style: AppFont.ralewaySubtitle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 40),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}