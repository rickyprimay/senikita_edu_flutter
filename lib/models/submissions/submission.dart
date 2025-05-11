class Submission {
    List<Datum> data;

    Submission({
        required this.data,
    });

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

}
