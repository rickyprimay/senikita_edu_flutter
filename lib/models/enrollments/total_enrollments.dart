class TotalEnrollments {
  final int totalCourse;
  final int totalCourseCompleted;
  final int totalCourseOnGoing;

  TotalEnrollments({
    required this.totalCourse,
    required this.totalCourseCompleted,
    required this.totalCourseOnGoing,
  });

  factory TotalEnrollments.fromJson(Map<String, dynamic> json) {
    return TotalEnrollments(
      totalCourse: json['total_course'],
      totalCourseCompleted: json['total_course_completed'],
      totalCourseOnGoing: json['total_course_on_going'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_course': totalCourse,
      'total_course_completed': totalCourseCompleted,
      'total_course_on_going': totalCourseOnGoing,
    };
  }
}