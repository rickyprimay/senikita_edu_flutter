import 'package:widya/models/meta/pagination_model.dart';

class Meta {
  bool success;
  String message;
  Pagination pagination;

  Meta({
    required this.success,
    required this.message,
    required this.pagination,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      success: json['success'],
      message: json['message'],
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'pagination': pagination.toJson(),
    };
  }
}