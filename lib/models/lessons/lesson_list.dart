import 'package:widya/models/lessons/additionals_materials.dart';
import 'package:widya/models/lessons/lesson.dart';

class LessonList {
  final List<Lesson> data;
  final List<AdditionalMaterial> additionalMaterials;

  LessonList({
    required this.data,
    required this.additionalMaterials,
  });

  factory LessonList.fromJson(Map<String, dynamic> json) {
    return LessonList(
      data: List<Lesson>.from(json['data'].map((x) => Lesson.fromJson(x))),
      additionalMaterials: List<AdditionalMaterial>.from(json['additional_materials'].map((x) => AdditionalMaterial.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'additional_materials': List<dynamic>.from(additionalMaterials.map((x) => x.toJson())),
    };
  }
}
