class Submission {
    List<Datum> data;

    Submission({
        required this.data,
    });

    factory Submission.fromJson(Map<String, dynamic> json) {
        return Submission(
            data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    int userId;
    String submission;
    String filePath;
    String status;
    dynamic feedback;
    dynamic score;
    DateTime createdAt;
    DateTime updatedAt;
    int lessonId;
    int isPublished;

    Datum({
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
    });

    factory Datum.fromJson(Map<String, dynamic> json) {
        return Datum(
            id: json['id'],
            userId: json['user_id'],
            submission: json['submission'],
            filePath: json['file_path'],
            status: json['status'],
            feedback: json['feedback'],
            score: json['score'],
            createdAt: DateTime.parse(json['created_at']),
            updatedAt: DateTime.parse(json['updated_at']),
            lessonId: json['lesson_id'],
            isPublished: json['is_published'],
        );
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'submission': submission,
        'file_path': filePath,
        'status': status,
        'feedback': feedback,
        'score': score,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'lesson_id': lessonId,
        'is_published': isPublished,
    };
}