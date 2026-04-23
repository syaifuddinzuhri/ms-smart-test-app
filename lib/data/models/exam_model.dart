enum ExamStatus { Pending, Ongoing, Pause, Completed }

class Exam {
  final String title;
  final String subject;
  final String duration;
  final String startAt;
  final String endAt;
  final ExamStatus status; // Menggunakan Enum
  final double? score;
  final String? resultStatus;

  Exam({
    required this.title,
    required this.subject,
    required this.duration,
    required this.startAt,
    required this.endAt,
    required this.status,
    this.score,
    this.resultStatus,
  });
}