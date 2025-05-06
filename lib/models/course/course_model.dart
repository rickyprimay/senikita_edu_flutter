import 'package:widya/models/category/category.dart';
import 'package:widya/models/instructor/instructor_model.dart';

class Course {
  int id;
  String title;
  String description;
  int certificateAvailable;
  String slug;
  String status;
  String thumbnail;
  Category? category;
  Instructor? instructor;
  int duration;
  String level;
  String? createdAt;
  String? updatedAt;

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
    this.createdAt,
    this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      certificateAvailable: json['certificate_available'],
      slug: json['slug'],
      status: json['status'],
      thumbnail: json['thumbnail'],
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      instructor: json['instructor'] != null ? Instructor.fromJson(json['instructor']) : null,
      duration: json['duration'],
      level: json['level'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      'category': category?.toJson(),
      'instructor': instructor?.toJson(),
      'duration': duration,
      'level': level,
    };
  }
}