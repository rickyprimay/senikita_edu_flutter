class CompletionStats {
  final int totalLessons;
  final int completedLessons;
  final double completionPercentage;

  CompletionStats({
    required this.totalLessons,
    required this.completedLessons,
    required this.completionPercentage,
  });

  factory CompletionStats.fromJson(Map<String, dynamic> json) {
    return CompletionStats(
      totalLessons: json['total_lessons'] as int,
      completedLessons: json['completed_lessons'] as int,
      completionPercentage: (json['completion_percentage'] is int)
          ? (json['completion_percentage'] as int).toDouble()
          : json['completion_percentage'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_lessons': totalLessons,
      'completed_lessons': completedLessons,
      'completion_percentage': completionPercentage,
    };
  }
}
