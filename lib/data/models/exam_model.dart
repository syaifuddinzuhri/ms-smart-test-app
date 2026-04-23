import 'package:ms_smart_test/data/models/exam_session_model.dart';

enum ExamStatus { pending, ongoing, pause, completed }

class ExamModel {
  final String id;
  final String title;
  final String status;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final Category category;
  final Subject subject;
  final String passingGrade;
  final bool showResultToStudent;
  final List<ExamSessionModel> sessions;

  ExamModel({
    required this.id,
    required this.title,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.category,
    required this.subject,
    required this.showResultToStudent,
    required this.passingGrade,
    required this.sessions,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      duration: json['duration'],
      category: Category.fromJson(json['category']),
      showResultToStudent: json['show_result_to_student'],
      subject: Subject.fromJson(json['subject']),
      passingGrade: json['passing_grade'],
      sessions: (json['sessions'] as List?)
          ?.map((s) => ExamSessionModel.fromJson(s))
          .toList() ?? [],
    );
  }

  ExamSessionModel? get latestSession => sessions.isNotEmpty ? sessions.first : null;
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Subject {
  final String id;
  final String name;
  final String code;

  Subject({required this.id, required this.name, required this.code});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }
}