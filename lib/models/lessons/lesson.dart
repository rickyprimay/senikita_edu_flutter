class Lesson {
  final int? id;
  final int? courseId;
  final int? order;
  final String? title;
  final bool isCompleted;
  final String? slug;
  final String? type;
  final String? description;
  final String? content;
  final String? videoUrl;
  final int? duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  Lesson({
    this.id,
    this.courseId,
    this.order,
    this.title,
    required this.isCompleted,
    this.slug,
    this.type,
    this.description,
    this.content,
    this.videoUrl,
    this.duration,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? 0,
      courseId: json['course_id'] ?? 0,
      order: json['order'] ?? 0,
      title: json['title'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      slug: json['slug'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      videoUrl: json['video_url'] ?? '',
      duration: json['duration'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'order': order,
      'title': title,
      'is_completed': isCompleted,
      'slug': slug,
      'type': type,
      'description': description,
      'content': content,
      'video_url': videoUrl,
      'duration': duration,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}