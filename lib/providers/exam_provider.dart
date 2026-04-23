import 'package:flutter/material.dart';
import 'package:ms_smart_test/data/models/exam_model.dart';
import 'package:ms_smart_test/data/services/exam_service.dart';

class ExamProvider extends ChangeNotifier {
  final ExamService _examService = ExamService();

  Map<String, List<ExamModel>> _examMap = {
    'pending': [],
    'active': [],
    'completed': [],
  };

  bool _isLoading = false;
  String? _error;

  List<ExamModel> getExamsByStatus(String status) => _examMap[status] ?? [];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchExams(String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _examService.getExamsByStatus(status);

      if (response.data['status'] == true) {
        final List<dynamic> rawData = response.data['data'];

        _examMap[status] = rawData.map((json) => ExamModel.fromJson(json)).toList();
      } else {
        _error = response.data['message'] ?? "Gagal mengambil data";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}