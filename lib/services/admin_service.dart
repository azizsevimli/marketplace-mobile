import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core/network/dio_client.dart';
import '../core/storage/secure_storage.dart';
import '../models/admin_model.dart';
import '../models/admin_stats_model.dart';

class AdminService() {
  static final _dio = DioClient.dio;

  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final token = await StorageService.getToken();
      final response = await _dio.post(
        '/admin/users/admins/new',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phone': phone,
          'password': password,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final String message = response.data['message'];

      if (response.data['success'] != true) {
        return {'userId': null, 'message': message};
      }

      final String userId = response.data['userId'];

      return {'userId': userId, 'message': message};
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return {'userId': null, 'message': e.message};
    }
  }

  static Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.get(
          '/admin/dashboard',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          return {'stats': null, 'message': response.data['message']};
        }

        final message = response.data['message'];
        final stats = AdminStatsModel.fromJson(response.data['stats']);

        return {'stats': stats, 'message': message};
      } else {
        await StorageService.deleteToken();
        return {'stats': null, 'message': 'Yetkisiz erişim (Token bulunmuyor)'};
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return {'stats': null, 'message': e.message};
    }
  }

  static Future<Map<String, dynamic>> getAdmins() async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.get(
          '/admin/users/admins',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          return {'message': response.data['message'], 'admins': null};
        }

        final List responseList = response.data['admins'];

        final List<AdminModel> list = responseList
            .map((i) => AdminModel.fromJson(Map<String, dynamic>.from(i)))
            .toList();

        return {'message': response.data['message'], 'admins': list};
      } else {
        await StorageService.deleteToken();
        return {
          'message': 'Yetkisiz Erişim (Token bulunmuyor)',
          'admins': null,
        };
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return {'message': e.message, 'admins': null};
    }
  }
}
