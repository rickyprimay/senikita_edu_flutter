import 'package:widya/models/course/course_model.dart';

class Enrollments {
  int id;
  int userId;
  int courseId;
  String status;
  String? completedAt;
  String createdAt;
  String updatedAt;
  Course course;

  Enrollments({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.status,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.course,
  });

  factory Enrollments.fromJson(Map<String, dynamic> json) {
    return Enrollments(
      id: json['id'],
      userId: json['user_id'],
      courseId: json['course_id'],
      status: json['status'],
      completedAt: json['completed_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      course: Course.fromJson(json['course']),
    );
  }
}