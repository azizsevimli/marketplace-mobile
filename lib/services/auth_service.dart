import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core/network/dio_client.dart';
import '../core/storage/secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  static final _dio = DioClient.dio;

  static Future<UserModel?> login(
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.data['success'] != true) {
        return null;
      }

      final user = UserModel.fromJson(response.data['user']);

      if (role != user.role) {
        debugPrint(
          'Kullanıcı rolü eşleşmiyor. '
          'Beklenen: $role, Alınan: ${user.role}',
        );
        return null;
      }

      final token = response.data['token'];
      await StorageService.saveToken(token);

      return user;
    } on DioException catch (e) {
      debugPrint('Type: ${e.type}');
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Giriş Hatası [Status]: ${e.response?.statusCode}');
      debugPrint('Giriş Hatası [Body]: ${e.response?.data}');

      return null;
    }
  }

  static Future<UserModel?> checkUser(String role) async {
    final token = await StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      try {
        final response = await _dio.get(
          '/auth/me',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          return null;
        }

        final user = UserModel.fromJson(response.data['user']);

        if (role != user.role) {
          debugPrint(
            'Kullanıcı rolü eşleşmiyor. '
            'Beklenen: $role, Alınan: ${user.role}',
          );
          return null;
        }

        return user;
      } on DioException catch (e) {
        debugPrint('Type: ${e.type}');
        debugPrint('Message: ${e.message}');
        debugPrint('Error: ${e.error}');
        debugPrint('Giriş Hatası [Status]: ${e.response?.statusCode}');
        debugPrint('Giriş Hatası [Body]: ${e.response?.data}');
        return null;
      }
    } else {
      await StorageService.deleteToken();
      debugPrint('Token bulunmuyor.');
      return null;
    }
  }
}
