import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/provider/category_provider.dart';
import 'package:widya/viewModel/category_view_model.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

class CategorySliderWidget extends StatelessWidget {
  const CategorySliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: CategoryViewModel().getCachedCategoryIdAndName(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 50);
        }

        final cachedCategories = snapshot.data ?? [];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          height: 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 20),
                _buildCategoryItem(context, label: "Semua"),

                ...cachedCategories.map((category) {
                  final isLast = cachedCategories.last['id'] == category['id'];
                  return _buildCategoryItem(
                    context,
                    label: category['name'],
                    isLast: isLast,
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(BuildContext context, {
    required String label,
    bool isLast = false,
  }) {
    final selectedLabel = context.watch<CategoryProvider>().selectedLabel;
    final isSelected = label == selectedLabel;

    return GestureDetector(
      onTap: () {
        context.read<CategoryProvider>().selectCategory(label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.only(right: isLast ? 20 : 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: AnimatedScale(
          scale: isSelected ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Text(
            label,
            style: AppFont.ralewaySubtitle.copyWith(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
