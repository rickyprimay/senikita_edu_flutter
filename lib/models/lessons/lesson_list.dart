import 'package:widya/models/lessons/lesson.dart';

class LessonList {
  final List<Lesson> data;

  LessonList({
    required this.data,
  });

  factory LessonList.fromJson(Map<String, dynamic> json) {
    return LessonList(
      data: List<Lesson>.from(json['data'].map((x) => Lesson.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}
