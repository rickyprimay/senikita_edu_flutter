import 'package:flutter/widgets.dart';
import 'package:widya/models/course/course_model.dart';
import 'package:widya/repository/course_repository.dart';
import 'package:widya/res/widgets/logger.dart';

class CourseDetailProvider with ChangeNotifier {
  final CourseRepository _courseRepository = CourseRepository();

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Course? _courseDetail;
  Course? get courseDetail => _courseDetail;

}
