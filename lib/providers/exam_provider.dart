import 'package:flutter/material.dart';
import 'package:ms_smart_test/data/models/exam_model.dart';
import 'package:ms_smart_test/data/models/question_model.dart';
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
  String? _sessionToken;
  String? _examId;
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  List<ExamModel> getExamsByStatus(String status) => _examMap[status] ?? [];
  List<QuestionModel> _questions = [];

  List<QuestionModel> get questions => _questions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<Map<String, dynamic>> fetchExamQuestions(String examId) async {
    try {
      final sessionRes = await _examService.getExamSession(examId);
      final sessionData = sessionRes.data['data'];
      final String sessionToken = sessionData['token'];
      final String expiresAtStr = sessionData['expires_at'];

      final questionRes = await _examService.getExamQuestions(sessionToken);
      final List rawQuestions = questionRes.data['data'];

      _questions = rawQuestions.map((q) => QuestionModel.fromJson(q)).toList();

      final expiresAt = DateTime.parse(expiresAtStr).toLocal();
      final diff = expiresAt.difference(DateTime.now()).inSeconds;

      _sessionToken = sessionToken;
      _examId = sessionData['exam_id'];
      notifyListeners();
      return {'seconds': diff > 0 ? diff : 0};
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchExams(String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _examService.getExamsByStatus(status);

      if (response.data['status'] == true) {
        final List<dynamic> rawData = response.data['data'];

        _examMap[status] = rawData
            .map((json) => ExamModel.fromJson(json))
            .toList();
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

  Future<void> pauseActiveSessions() async {
    try {
      await _examService.pauseSessions();
    } catch (e) {
      debugPrint("Error pausing sessions: $e");
    }
  }

  Future<bool> startSession(String examId, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _examService.startExamSession(examId, token);

      if (response.data['status'] == true) {
        return true;
      } else {
        _error = response.data['message'] ?? "Token salah";
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> fetchRemainingSeconds(String examId) async {
    try {
      final response = await _examService.getExamSession(examId);
      if (response.data['status'] == true) {
        final expiresAtStr = response.data['data']['expires_at'];
        if (expiresAtStr != null) {
          final expiresAt = DateTime.parse(expiresAtStr).toLocal();
          final now = DateTime.now();
          final diff = expiresAt.difference(now).inSeconds;
          return diff > 0 ? diff : 0;
        }
      }
      return 0;
    } catch (e) {
      debugPrint("Error fetch session: $e");
      return 0;
    }
  }

  Future<void> pauseExamSession(String examId) async {
    try {
      await _examService.pauseExamSession(examId);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> syncAnswer(QuestionModel question) async {
    if (_sessionToken == null) false;

    _isSyncing = true;
    notifyListeners(); // Beritahu UI bahwa sedang loading

    try {
      dynamic payload;

      // Menentukan isi jawaban berdasarkan tipe soal (Sama seperti logika PHP)
      switch (question.type) {
        case QuestionType.single_choice:
        case QuestionType.true_false:
          // Kirim ID opsi yang dipilih
          payload = question.selectedAnswerIndex != null
              ? question.options[question.selectedAnswerIndex!].id
              : null;
          break;
        case QuestionType.multiple_choice:
          // Kirim List ID opsi
          payload = question.selectedAnswerIndices
              .map((idx) => question.options[idx].id)
              .toList();
          break;
        case QuestionType.short_answer:
        case QuestionType.essay:
          payload = question.textAnswer;
          break;
      }

      final response = await _examService.saveAnswer(
        examId: _examId!,
        questionId: question.id,
        answer: payload,
        isFlagged: question.isFlagged,
        sessionToken: _sessionToken!,
      );

      debugPrint("Jawaban soal ${question.id} tersinkron ke server.");
      return response.data['status'] == true;
    } catch (e) {
      debugPrint("Gagal sinkronisasi: $e");
      return false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<bool> finalizeExam(String examId, {bool isTimeout = false}) async {
    if (_sessionToken == null) return false;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _examService.finalizeExam(
        examId,
        _sessionToken!,
        isTimeout,
      );
      return response.data['status'] == true;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAndSyncAnswers(String examId) async {
    try {
      final response = await _examService.getSavedAnswers(
        examId,
        _sessionToken!,
      );
      final List savedData = response.data['data'];

      for (var answer in savedData) {
        // Cari soal di list lokal berdasarkan ID
        final questionIndex = _questions.indexWhere(
          (q) => q.id == answer['question_id'],
        );

        if (questionIndex != -1) {
          var q = _questions[questionIndex];
          q.isFlagged = answer['is_doubtful'] ?? false;
          q.textAnswer = answer['answer_text'] ?? "";

          // Sync Pilihan Ganda (Single & Multiple)
          List<dynamic> serverOptionIds = answer['selected_option_ids'] ?? [];

          if (q.type == QuestionType.single_choice ||
              q.type == QuestionType.true_false) {
            if (serverOptionIds.isNotEmpty) {
              // Cari index berdasarkan ID opsi
              q.selectedAnswerIndex = q.options.indexWhere(
                (opt) => opt.id == serverOptionIds.first,
              );
            }
          } else if (q.type == QuestionType.multiple_choice) {
            q.selectedAnswerIndices = [];
            for (var id in serverOptionIds) {
              int idx = q.options.indexWhere((opt) => opt.id == id);
              if (idx != -1) q.selectedAnswerIndices.add(idx);
            }
          }
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error sync answers: $e");
    }
  }
}
