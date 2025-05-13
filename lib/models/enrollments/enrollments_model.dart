import 'package:widya/models/course/course_model.dart';
import 'package:widya/models/enrollments/completion_stats.dart';

class Enrollments {
  final int id;
  final String userId;
  final String courseId;
  final String status;
  final String? completedAt;
  final String createdAt;
  final CompletionStats? completionStats;
  final Course course;

  Enrollments({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.status,
    this.completedAt,
    required this.createdAt,
    this.completionStats,
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
      completionStats: json['completion_stats'] != null ? CompletionStats.fromJson(json['completion_stats']) : null,
      course: Course.fromJson(json['course']),
    );
  }
}