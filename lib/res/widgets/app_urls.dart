class AppUrls {
  static const baseUrl = "https://eduapi.senikita.my.id/api";

  static const loginEndPoint = "$baseUrl/auth/google/verify-code";
  static const getDetailPerson = "$baseUrl/user";

  static const getCategory = "$baseUrl/categories";

  static String getCourse({int? categoryId, String? search}) {
    String url = "$baseUrl/courses";
    
    List<String> queryParameters = [];
    
    if (categoryId != null) {
      queryParameters.add("category_id=$categoryId");
    }
    
    if (search != null && search.isNotEmpty) {
      queryParameters.add("search=$search");
    }

    if (queryParameters.isNotEmpty) {
      url += "?${queryParameters.join('&')}";
    }

    return url;
  }

  static String getCourseDetail(int courseId) {
    return "$baseUrl/courses/$courseId";
  }

  static String getEnrollments = "$baseUrl/enrollments";
  static String postEnrollments = "$baseUrl/enrollments";

}