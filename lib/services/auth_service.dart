import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core/network/dio_client.dart';
import '../core/storage/secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  static final _dio = DioClient.dio;

  static Future<Map<String, dynamic>?> register(
    String name,
    String surname,
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'firstName': name,
          'lastName': surname,
          'email': email,
          'password': password,
          'role': role,
        },
      );

      if (response.data['success'] != true) {
        return {'user': null, 'message': response.data['message']};
      }

      final message = response.data['message'];
      final userId = response.data['userId'];
      final token = response.data['token'];
      await StorageService.saveToken(token);

      return {'userId': userId, 'message': message};
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Kayıt Hatası [Status]: ${e.response?.statusCode}');
      debugPrint('Kayıt Hatası [Body]: ${e.response?.data}');

      return {
        'user': null,
        'message': e.response?.data['message'] ?? 'Kayıt başarısız oldu.',
      };
    }
  }

  static Future<Map<String, dynamic>?> login(
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
        return {'user': null, 'message': response.data['message']};
      }

      final user = UserModel.fromJson(response.data['user']);

      if (role != user.role) {
        return {
          'user': null,
          'message': 'Lütfen ${user.role} panelinden giriş yapın.',
        };
      }

      final token = response.data['token'];
      await StorageService.saveToken(token);

      return {'user': user, 'message': response.data['message']};
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Giriş Hatası [Status]: ${e.response?.statusCode}');
      debugPrint('Giriş Hatası [Body]: ${e.response?.data}');

      return {
        'user': null,
        'message': e.response?.data['message'] ?? 'Giriş başarısız oldu.',
      };
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
