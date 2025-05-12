class Gallery {
    final bool success;
    final String message;
    final List<GalleryList> data;

    Gallery({
        required this.success,
        required this.message,
        required this.data,
    });

    factory Gallery.fromJson(Map<String, dynamic> json) {
        return Gallery(
            success: json['success'] ?? false,
            message: json['message'] ?? '',
            data: json['data'] != null
                ? List<GalleryList>.from(json['data'].map((x) => GalleryList.fromJson(x)))
                : [],
        );
    }
}

class GalleryList {
    final int id;
    final int userId;
    final String submission;
    final String filePath;
    final String status;
    final String feedback;
    final int score;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int lessonId;
    final int isPublished;
    final String type; 
    final User user;

    GalleryList({
        required this.id,
        required this.userId,
        required this.submission,
        required this.filePath,
        required this.status,
        required this.feedback,
        required this.score,
        required this.createdAt,
        required this.updatedAt,
        required this.lessonId,
        required this.isPublished,
        required this.type,
        required this.user,
    });

    factory GalleryList.fromJson(Map<String, dynamic> json) {
        return GalleryList(
            id: json['id'] ?? 0,
            userId: json['user_id'] ?? 0,
            submission: json['submission'] ?? '',
            filePath: json['file_path'] ?? '',
            status: json['status'] ?? '',
            feedback: json['feedback'] ?? '',
            score: json['score'] ?? 0,
            createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
            updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
            lessonId: json['lesson_id'] ?? 0,
            isPublished: json['is_published'] ?? 0,
            type: json['type'] ?? '', 
            user: User.fromJson(json['user'] ?? {'name': 'Unknown'}),
        );
    }
}

class User {
    final String name;

    User({
        required this.name,
    });

    factory User.fromJson(Map<String, dynamic> json) {
        return User(
            name: json['name'] ?? '',
        );
    }
}