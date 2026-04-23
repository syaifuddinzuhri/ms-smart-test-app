import 'package:dio/dio.dart';
import '../../core/api/dio_client.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<Response> login(String username, String password) async {
    return await _dio.post('/v1/auth/login', data: {
      'username': username,
      'password': password,
    });
  }

  Future<Response> getMe() async {
    return await _dio.get('/v1/auth/me');
  }

  Future<Response> logout() async {
    return await _dio.post('/v1/auth/logout');
  }
}