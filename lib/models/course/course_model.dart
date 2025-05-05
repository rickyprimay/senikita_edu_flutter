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
  Category category;
  Instructor instructor;
  int duration;
  String level;

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
      category: Category.fromJson(json['category']),
      instructor: Instructor.fromJson(json['instructor']),
      duration: json['duration'],
      level: json['level'],
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
      'category': category.toJson(),
      'instructor': instructor.toJson(),
      'duration': duration,
      'level': level,
    };
  }
}