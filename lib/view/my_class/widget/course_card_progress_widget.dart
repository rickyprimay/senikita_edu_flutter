import 'package:flutter/material.dart';
import 'package:widya/res/helpers/get_level_color.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

class CourseCardWithProgress extends StatefulWidget {
  final String title;
  final String subtitle;
  final String duration;
  final String author;
  final String status;
  final String? imageUrl;
  final double progress;
  final VoidCallback? onTap;
  final String levelLabel;

  const CourseCardWithProgress({
    super.key,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.author,
    required this.status,
    this.imageUrl,
    required this.progress,
    this.onTap,
    required this.levelLabel,
  });

  @override
  _CourseCardWithProgressState createState() => _CourseCardWithProgressState();
}

class _CourseCardWithProgressState extends State<CourseCardWithProgress> {
  bool _isPressed = false;

  void _setPressed(bool pressed) {
    setState(() {
      _isPressed = pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.progress).toStringAsFixed(0);

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) {
        _setPressed(false);
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: _isPressed ? AppColors.tertiary.withAlpha(80) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow: _isPressed
                    ? [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppColors.primary.withAlpha(120),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                              ? Image.network(
                                  widget.imageUrl!,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image, color: Colors.grey, size: 40);
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                      ),
                                    );
                                  },
                                )
                              : const Icon(Icons.image, color: Colors.grey, size: 40),
                        ),

                        if (widget.levelLabel.isNotEmpty)
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: getLevelColor(widget.levelLabel),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${widget.levelLabel[0].toUpperCase()}${widget.levelLabel.substring(1)}',
                                style: AppFont.nunitoSubtitle.copyWith(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: AppFont.crimsonTextHeader.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Mentor Kelas: ${widget.author}",
                            style: AppFont.nunitoSubtitle.copyWith(
                              fontSize: 11,
                              color: Colors.black.withAlpha(140),
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: widget.progress / 100,
                            color: AppColors.tertiary,
                            backgroundColor: Colors.grey[200],
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.timer, size: 14, color: AppColors.tertiary),
                              const SizedBox(width: 4),
                              Text(
                                widget.duration,
                                style: AppFont.nunitoSubtitle.copyWith(
                                  color: AppColors.tertiary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "$percentage% Selesai",
                                style: AppFont.nunitoSubtitle.copyWith(
                                  fontSize: 12,
                                  color: Colors.black.withAlpha(120),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (widget.status.toLowerCase() == "completed")
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.customGreen,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Telah Diselesaikan',
                        style: AppFont.ralewaySubtitle.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
