import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ms_smart_test/ui/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main_navigator.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json'
      ),
    );

    // Interceptor untuk Log dan Auth Token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          final prefs = await SharedPreferences.getInstance();

          // 🔥 Hapus token
          await prefs.remove('auth_token');

          // 🔥 Redirect ke login (reset stack)
          final navigator = MainNavigator.navigatorKey.currentState;

          if (navigator != null) {
            navigator.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
            );
          }
        }

        return handler.next(e);
      },
    ));

    _dio.interceptors.add(aliceDioAdapter);
  }

  Dio get dio => _dio;
}