class Certificate {
    bool success;
    String message;
    List<CertificateList> data;

    Certificate({
        required this.success,
        required this.message,
        required this.data,
    });

    factory Certificate.fromJson(Map<String, dynamic> json) {
        return Certificate(
            success: json['success'] ?? false,
            message: json['message'] ?? '',
            data: List<CertificateList>.from(
                (json['data'] ?? []).map((x) => CertificateList.fromJson(x))
            ),
        );
    }
}

class CertificateList {
    int id;
    int enrollmentId;
    String certificateNumber;
    String certificateImage;
    String certificatePdf;
    DateTime createdAt;
    DateTime updatedAt;
    Enrollment enrollment;

    CertificateList({
        required this.id,
        required this.enrollmentId,
        required this.certificateNumber,
        required this.certificateImage,
        required this.certificatePdf,
        required this.createdAt,
        required this.updatedAt,
        required this.enrollment,
    });

    factory CertificateList.fromJson(Map<String, dynamic> json) {
        return CertificateList(
            id: json['id'] ?? 0,
            enrollmentId: json['enrollment_id'] ?? 0,
            certificateNumber: json['certificate_number'] ?? '',
            certificateImage: json['certificate_image'] ?? '',
            certificatePdf: json['certificate_pdf'] ?? '',
            createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
            updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
            enrollment: Enrollment.fromJson(json['enrollment'] ?? {}),
        );
    }
}

class Enrollment {
    int id;
    int userId;
    int courseId;
    String status;
    DateTime completedAt;
    DateTime createdAt;
    DateTime updatedAt;
    Course course;

    Enrollment({
        required this.id,
        required this.userId,
        required this.courseId,
        required this.status,
        required this.completedAt,
        required this.createdAt,
        required this.updatedAt,
        required this.course,
    });

    factory Enrollment.fromJson(Map<String, dynamic> json) {
        return Enrollment(
            id: json['id'] ?? 0,
            userId: json['user_id'] ?? 0,
            courseId: json['course_id'] ?? 0,
            status: json['status'] ?? '',
            completedAt: DateTime.parse(json['completed_at'] ?? DateTime.now().toIso8601String()),
            createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
            updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
            course: Course.fromJson(json['course'] ?? {}),
        );
    }
}

class Course {
    int id;
    String title;
    String description;
    int certificateAvailable;
    String thumbnail;
    String slug;
    String level;
    String status;
    int instructorId;
    DateTime createdAt;
    DateTime updatedAt;
    String previewVideo;

    Course({
        required this.id,
        required this.title,
        required this.description,
        required this.certificateAvailable,
        required this.thumbnail,
        required this.slug,
        required this.level,
        required this.status,
        required this.instructorId,
        required this.createdAt,
        required this.updatedAt,
        required this.previewVideo,
    });

    factory Course.fromJson(Map<String, dynamic> json) {
        return Course(
            id: json['id'] ?? 0,
            title: json['title'] ?? '',
            description: json['description'] ?? '',
            certificateAvailable: json['certificate_available'] ?? 0,
            thumbnail: json['thumbnail'] ?? '',
            slug: json['slug'] ?? '',
            level: json['level'] ?? '',
            status: json['status'] ?? '',
            instructorId: json['instructor_id'] ?? 0,
            createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
            updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
            previewVideo: json['preview_video'] ?? '',
        );
    }
}