class ProfileStats {
  final int examsDone;
  final int examsPending;
  final double highestScore;
  final double averageScore;

  ProfileStats({
    required this.examsDone,
    required this.examsPending,
    required this.highestScore,
    required this.averageScore,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      examsDone: json['exams_done'] ?? 0,
      examsPending: json['exams_pending'] ?? 0,
      highestScore: double.tryParse(json['highest_score'].toString()) ?? 0.0,
      averageScore: double.tryParse(json['average_score'].toString()) ?? 0.0,
    );
  }
}