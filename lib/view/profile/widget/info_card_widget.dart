import 'package:flutter/material.dart';
import 'package:widya/res/widgets/fonts.dart';

class InfoCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String label;
  final String value;
  final Color cardColor;
  final Color borderColor;

  const InfoCardWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.label,
    required this.value,
    this.cardColor = const Color(0xFFF9F9E8),
    this.borderColor = const Color(0xFF8A8F64), 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Left side content (text)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppFont.crimsonTextHeader.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "$value $label",
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 15,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          
          Expanded(
            flex: 2,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: borderColor.withAlpha(200),
                  size: 36,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}