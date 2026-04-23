import 'package:ms_smart_test/data/models/student_model.dart';

class User {
  final String id;
  final String username;
  final String name;
  final String? email;
  final Student? student;

  User({
    required this.id,
    required this.username,
    required this.name,
    this.email,
    this.student,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      student: json['student'] != null
          ? Student.fromJson(json['student'])
          : null,
    );
  }
}