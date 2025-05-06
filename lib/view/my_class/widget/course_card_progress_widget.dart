import 'package:flutter/material.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

class CourseCardWithProgress extends StatefulWidget {
  final String title;
  final String subtitle;
  final String duration;
  final String author;
  final String? imageUrl;
  final double progress; 

  const CourseCardWithProgress({
    super.key,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.author,
    this.imageUrl,
    required this.progress,
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
    final percentage = (widget.progress * 100).toStringAsFixed(0);

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _isPressed ? AppColors.tertiary.withAlpha(80) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withAlpha(120),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                      ? Image.network(
                          widget.imageUrl!,
                          fit: BoxFit.cover,
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
                      // const SizedBox(height: 6),
                      // Text(
                      //   widget.subtitle,
                      //   style: AppFont.ralewaySubtitle.copyWith(
                      //     fontSize: 12,
                      //     color: Colors.grey,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
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
                        value: widget.progress,
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
      ),
    );
  }
}
