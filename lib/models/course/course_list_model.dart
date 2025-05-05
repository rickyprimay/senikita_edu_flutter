import 'package:widya/models/course/course_model.dart';
import 'package:widya/models/meta/meta_model.dart';

class CourseListResponse {
  List<Course> data;
  Meta meta;

  CourseListResponse({required this.data, required this.meta});

  factory CourseListResponse.fromJson(Map<String, dynamic> json) {
    return CourseListResponse(
      data: List<Course>.from(json['data'].map((course) => Course.fromJson(course))),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((course) => course.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}