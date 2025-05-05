import 'package:flutter/material.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

Widget courseCard({
  required Color color,
  required String title,
  required String subtitle,
  required String duration,
  required IconData icon,
  required String author,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: AppColors.primary.withAlpha(120), 
        width: 1,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.primary.withAlpha(120),
              width: 1,
            ),
          ),
          child: Icon(icon, size: 40, color: Colors.black87),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFont.crimsonTextHeader.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.timer, size: 14, color: AppColors.tertiary),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: AppFont.nunitoSubtitle.copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
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
  );
}
