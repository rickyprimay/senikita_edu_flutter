import 'package:widya/models/enrollments/enrollments_model.dart';
import 'package:widya/models/meta/meta_model.dart';

class EnrollmentsListResponse {
  List<Enrollments> data;
  Meta? meta;

  EnrollmentsListResponse({required this.data, this.meta});

  factory EnrollmentsListResponse.fromJson(Map<String, dynamic> json) {
    return EnrollmentsListResponse(
      data: (json['data'] as List).map((item) => Enrollments.fromJson(item)).toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}