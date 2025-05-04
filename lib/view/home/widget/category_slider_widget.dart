import 'package:flutter/material.dart';
import 'package:senikita_edu/res/widgets/colors.dart';
import 'package:senikita_edu/res/widgets/fonts.dart';

class CategorySliderWidget extends StatelessWidget {
  const CategorySliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 20),
            _buildCategoryItem(
              label: "Semua",
              isSelected: true,
            ),
            _buildCategoryItem(label: "Seni Tari"),
            _buildCategoryItem(label: "Seni Batik"),
            _buildCategoryItem(label: "Seni Musik"),
            _buildCategoryItem(label: "Seni Rupa", isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required String label,
    bool isSelected = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.only(right: isLast ? 20 : 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: AppFont.nunitoSubtitle.copyWith(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
