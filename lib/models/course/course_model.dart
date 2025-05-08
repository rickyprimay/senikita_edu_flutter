import 'package:widya/models/instructor/instructor_model.dart';

class Course {
  final int id;
  final String title;
  final String description;
  final int certificateAvailable;
  final String slug;
  final String status;
  final String thumbnail;
  final List<String> category;
  final Instructor instructor;
  final String duration;
  final String level;
  final int enrolledCount;
  final int rating;
  final int lessonsCount;
  final List<String>? sneakpeeks;
  final List<String>? requirements;
  final String? createdAt;
  final String? updatedAt;
  final bool? isEnrolled;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.certificateAvailable,
    required this.slug,
    required this.status,
    required this.thumbnail,
    required this.category,
    required this.instructor,
    required this.duration,
    required this.level,
    required this.enrolledCount,
    required this.rating,
    required this.lessonsCount,
    this.sneakpeeks,
    this.requirements,
    this.createdAt,
    this.updatedAt,
    this.isEnrolled,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      certificateAvailable: json['certificate_available'] ?? 0,
      slug: json['slug'],
      status: json['status'],
      thumbnail: json['thumbnail'],
      category: List<String>.from(json['category']),
      instructor: Instructor.fromJson(json['instructor']),
      duration: json['duration'],
      level: json['level'],
      enrolledCount: json['enrolled_count'] ?? 0,
      rating: json['rating'] ?? 0,
      lessonsCount: json['lessons_count'] ?? 0,
      sneakpeeks: json['sneakpeeks'] != null ? List<String>.from(json['sneakpeeks']) : null,
      requirements: json['requirements'] != null ? List<String>.from(json['requirements']) : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isEnrolled: json['is_enrolled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'certificate_available': certificateAvailable,
      'slug': slug,
      'status': status,
      'thumbnail': thumbnail,
      'category': category,
      'instructor': instructor.toJson(), 
      'duration': duration,
      'level': level,
      'enrolled_count': enrolledCount,
      'rating': rating,
      'lessons_count': lessonsCount,
      'sneakpeeks': sneakpeeks != null ? List<String>.from(sneakpeeks!) : null,
      'requirements': requirements != null ? List<String>.from(requirements!) : null,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_enrolled': isEnrolled,
    };
  }
}