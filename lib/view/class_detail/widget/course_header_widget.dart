import 'package:flutter/material.dart';
import 'package:widya/res/widgets/fonts.dart';

class CourseHeaderWidget extends StatelessWidget {
  final String courseName;
  final String courseDescription;
  
  const CourseHeaderWidget({
    Key? key,
    required this.courseName,
    required this.courseDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            courseName,
            style: AppFont.crimsonTextHeader.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            )
          ),
          const SizedBox(height: 4),
          Text(
            courseDescription,
            style: AppFont.ralewayHeader.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            )
          ),
        ],
      ),
    );
  }
}