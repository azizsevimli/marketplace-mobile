import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core/network/dio_client.dart';
import '../core/storage/secure_storage.dart';
import '../models/admin_stats_model.dart';

class AdminService() {
  static final _dio = DioClient.dio;

  static Future<Map<String, dynamic>?> getDashboardStats() async {
    final token = await StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      try {
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
      } on DioException catch (e) {
        debugPrint('Message: ${e.message}');
        debugPrint('Error: ${e.error}');
        debugPrint('Hata [Status]: ${e.response?.statusCode}');
        debugPrint('Hata [Body]: ${e.response?.data}');
        await StorageService.deleteToken();
        return {'stats': null, 'message': e.message};
      }
    } else {
      return {'stats': null, 'message': 'Yetkisiz erişim (Token bulunmuyor)'};
    }
  }
}
