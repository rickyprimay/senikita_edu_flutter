class AppUrls {
  static const baseUrl = "https://eduapi.senikita.my.id/api";

  static const loginEndPoint = "$baseUrl/auth/google/verify-code";
  static const getDetailPerson = "$baseUrl/user";

  static const getCategory = "$baseUrl/categories";

  static String getCourse({int? categoryId, String? search, int? page}) {
    String url = "$baseUrl/courses";
    
    List<String> queryParameters = [];
    
    if (categoryId != null) {
      queryParameters.add("category_id=$categoryId");
    }
    
    if (search != null && search.isNotEmpty) {
      queryParameters.add("search=$search");
    }

    if (page != null) {
      queryParameters.add("?page=$page");
    }

    if (queryParameters.isNotEmpty) {
      url += "?${queryParameters.join('&')}";
    }
    return url;
  }

  static String getCourseMore({int? page}) {
    String url = "$baseUrl/courses";
    
    if (page != null) {
      url += "?page=$page";
    }

    return url;
  }

  static String getCourseDetail(int courseId) {
    return "$baseUrl/courses/$courseId";
  }

  static String getEnrollments = "$baseUrl/enrollments";

  static String getenrollmentsMore({int? page}) {
    String url = "$baseUrl/enrollments";
    
    if (page != null) {
      url += "?page=$page";
    }

    return url;
  }

  static const String getTotalEnrollments = '$baseUrl/enrollments/total-course';

  static String postEnrollments = "$baseUrl/enrollments";

  static String getCourseLessons(int courseId) {
    return "$baseUrl/course/lessons/$courseId";
  }

  static String getQuiz(int lessonId) {
    return "$baseUrl/quizzes/lesson/$lessonId";
  }

  static String submitQuiz(int lessonId) {
    return "$baseUrl/quizzes/lesson/$lessonId";
  }

  static String postCompleteLesson(int lessonId) {
    return "$baseUrl/lessons/$lessonId/complete";
  }

}