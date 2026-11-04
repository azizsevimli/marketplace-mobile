import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../core/storage/secure_storage.dart';
import '../core/utils/result.dart';
import '../models/user_model.dart';

class AuthService {
  static final _dio = DioClient.dio;
  static Options get _auth => Options(extra: {'requiresAuth': true});

  static Future<Result<String>> register(
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

      if (response.data['success']) {
        final String userId = response.data['userId'];
        // final String userRole = response.data['userRole'];
        final String token = response.data['token'];
        await StorageService.saveToken(token);

        return Result.ok(userId);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<UserModel>> login(
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.data['success']) {
        final token = response.data['token'];
        await StorageService.saveToken(token);

        final user = UserModel.fromJson(response.data['user']);

        return Result.ok(user);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<UserModel>> checkUser() async {
    try {
      final response = await _dio.get('/auth/me', options: _auth);

      if (response.data['success']) {
        final UserModel user = UserModel.fromJson(response.data['user']);

        return Result.ok(user);
      } else {
        await StorageService.deleteToken();
        return Result.error(Exception('Token bulunmuyor veya süresi geçmiş.'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<bool>> logout() async {
    try {
      await StorageService.deleteToken();
      return Result.ok(true);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
