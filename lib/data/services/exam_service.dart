import 'package:dio/dio.dart';
import 'package:ms_smart_test/core/api/dio_client.dart';

class ExamService {
  final Dio _dio = DioClient().dio;

  // Menambahkan query parameter 'status'
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
}