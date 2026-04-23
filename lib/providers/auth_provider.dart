import 'package:flutter/material.dart';
import 'package:ms_smart_test/core/error_helper.dart';
import 'package:ms_smart_test/data/models/profile_model.dart';
import 'package:ms_smart_test/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  ProfileModel? _profileData;
  String? _error;

  bool get isLoading => _isLoading;
  ProfileModel? get profileData => _profileData;
  String? get error => _error;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(username, password);

      final token = response.data['data']['access_token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      await getMe();

      return true;
    } on DioException catch (e) {
      _error = ErrorHelper.getMessage(e);
      return false;
    } catch (e, stack) {
      _error = "Terjadi kesalahan";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) return false;

    try {
      final response = await _authService.getMe();

      _profileData = ProfileModel.fromJson(response.data);
      notifyListeners();

      return true;
    } on DioException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> getMe() async {
    try {
      final response = await _authService.getMe();

      _profileData = ProfileModel.fromJson(response.data);
      notifyListeners();
    } on DioException catch (e) {
      _profileData = null;
    } catch (e) {
      _profileData = null;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } on DioException catch (e) {
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      _profileData = null;
      notifyListeners();

    }
  }
}