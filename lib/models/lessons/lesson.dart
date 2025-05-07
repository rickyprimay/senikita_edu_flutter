class Lesson {
  final int id;
  final int courseId;
  final int order;
  final String title;
  final String slug;
  final String type;
  final String description;
  final String content;
  final String videoUrl;
  final int duration;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lesson({
    required this.id,
    required this.courseId,
    required this.order,
    required this.title,
    required this.slug,
    required this.type,
    required this.description,
    required this.content,
    required this.videoUrl,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      courseId: json['course_id'],
      order: json['order'],
      title: json['title'],
      slug: json['slug'],
      type: json['type'],
      description: json['description'],
      content: json['content'],
      videoUrl: json['video_url'],
      duration: json['duration'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'order': order,
      'title': title,
      'slug': slug,
      'type': type,
      'description': description,
      'content': content,
      'video_url': videoUrl,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}