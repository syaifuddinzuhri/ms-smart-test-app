import 'package:dio/dio.dart';
import 'package:ms_smart_test/core/api/dio_client.dart';

class ExamService {
  final Dio _dio = DioClient().dio;

  Future<Response> startExamSession(String examId, String token) async {
    try {
      final response = await _dio.post(
        '/v1/exams/$examId/start-session',
        data: {'token': token},
      );
      return response;
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data['message'] ?? "Gagal memulai sesi ujian";
      throw errorMsg;
    }
  }

  Future<Response> pauseExamSession(String examId) async {
    try {
      final response = await _dio.post('/v1/exams/$examId/pause-session');
      return response;
    } on DioException catch (e) {
      final errorMsg = e.response?.data['message'] ?? "Gagal pause sesi ujian";
      throw errorMsg;
    }
  }

  Future<Response> pauseSessions() async {
    try {
      final response = await _dio.post('/v1/exams/pause-sessions');
      return response;
    } on DioException catch (e) {
      throw e.message ?? "Terjadi kesalahan pada server";
    }
  }

  Future<Response> getExamsByStatus(String status) async {
    try {
      final response = await _dio.get(
        '/v1/exams',
        queryParameters: {'status': status},
      );
      return response;
    } on DioException catch (e) {
      throw e.message ?? "Terjadi kesalahan pada server";
    }
  }

  Future<Response> getExamSession(String examId) async {
    try {
      final response = await _dio.get('/v1/exams/$examId/session');
      return response;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Gagal mengambil data sesi";
    }
  }

  Future<Response> getExamQuestions(String sessionToken) async {
    try {
      return await _dio.get(
        '/v1/exams/questions',
        queryParameters: {'token': sessionToken},
      );
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Gagal mengambil soal";
    }
  }

  Future<Response> saveAnswer({
    required String examId,
    required String questionId,
    required dynamic
    answer, // Bisa int (PG), List<int> (Multiple), atau String (Essay)
    required bool isFlagged,
    required String sessionToken,
  }) async {
    try {
      return await _dio.post(
        '/v1/exams/$examId/save-answer',
        queryParameters: {'token': sessionToken},
        data: {
          'question_id': questionId,
          'answer': answer,
          'is_doubtful': isFlagged,
        },
      );
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Gagal menyimpan jawaban";
    }
  }

  Future<Response> getSavedAnswers(String examId, String sessionToken) async {
    try {
      return await _dio.get(
        '/v1/exams/$examId/answers',
        queryParameters: {'token': sessionToken},
      );
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Gagal memuat jawaban tersimpan";
    }
  }

  Future<Response> finalizeExam(String examId, String sessionToken, bool isTimeout) async {
    try {
      return await _dio.post(
        '/v1/exams/$examId/finalize', // Sesuaikan endpoint Anda
        queryParameters: {'token': sessionToken},
        data: {
          'is_timeout': isTimeout
        }
      );
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Gagal mengakhiri ujian";
    }
  }
}
