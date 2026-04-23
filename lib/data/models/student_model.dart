
import 'package:ms_smart_test/data/models/classroom_model.dart';

class Student {
  final String id;
  final String nisn;
  final String? pob;
  final String? dob;
  final String gender;
  final Classroom classroom;

  Student({
    required this.id,
    required this.nisn,
    this.pob,
    this.dob,
    required this.gender,
    required this.classroom,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      nisn: json['nisn'],
      pob: json['pob'],
      dob: json['dob'],
      gender: json['gender'],
      classroom: Classroom.fromJson(json['classroom']),
    );
  }
}