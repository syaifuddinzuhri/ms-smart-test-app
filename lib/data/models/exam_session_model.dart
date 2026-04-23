class ExamSessionModel {
  final String id;
  final String examId;
  final String status;
  final DateTime? startedAt;
  final DateTime? expiresAt;
  final DateTime? finishedAt;
  final String totalScore;
  final int violationCount;
  final String deviceType;

  ExamSessionModel({
    required this.id,
    required this.examId,
    required this.status,
    this.startedAt,
    this.expiresAt,
    this.finishedAt,
    required this.totalScore,
    required this.violationCount,
    required this.deviceType,
  });

  factory ExamSessionModel.fromJson(Map<String, dynamic> json) {
    return ExamSessionModel(
      id: json['id'],
      examId: json['exam_id'],
      status: json['status'] ?? '',
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at']) : null,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      finishedAt: json['finished_at'] != null ? DateTime.parse(json['finished_at']) : null,
      totalScore: json['total_score'] ?? '0.00',
      violationCount: json['violation_count'] ?? 0,
      deviceType: json['device_type'] ?? '',
    );
  }
}