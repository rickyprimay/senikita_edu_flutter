import 'package:widya/models/enrollments/total_enrollments.dart';

class ListTotalEnrollments {
  final TotalEnrollments data;

  ListTotalEnrollments({
    required this.data,
  });

  factory ListTotalEnrollments.fromJson(Map<String, dynamic> json) {
    return ListTotalEnrollments(
      data: TotalEnrollments.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}