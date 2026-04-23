import 'package:ms_smart_test/data/models/major_model.dart';

class Classroom {
  final String id;
  final String name;
  final String code;
  final Major major;

  Classroom({
    required this.id,
    required this.name,
    required this.code,
    required this.major,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      major: Major.fromJson(json['major']),
    );
  }
}