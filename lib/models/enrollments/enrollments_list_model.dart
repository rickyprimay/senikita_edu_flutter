import 'package:widya/models/enrollments/enrollments_model.dart';

class EnrollmentsListResponse {
  int currentPage;
  List<Enrollments> data;

  EnrollmentsListResponse({required this.currentPage, required this.data});

  factory EnrollmentsListResponse.fromJson(Map<String, dynamic> json) {
    return EnrollmentsListResponse(
      currentPage: json['current_page'],
      data: (json['data'] as List).map((item) => Enrollments.fromJson(item)).toList(),
    );
  }
}