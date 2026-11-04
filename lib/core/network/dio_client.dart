import 'dart:async';

import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

class DioClient {
  static final Dio _dio = _initDio();
  static final _unauthorizedController = StreamController<void>.broadcast();

  static Dio get dio => _dio;
  static Stream<void> get onUnauthorized => _unauthorizedController.stream;

  static Dio _initDio() {
    final dioInstance = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    dioInstance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final requiresAuth = options.extra['requiresAuth'] ?? false;

          if (requiresAuth) {
            final token = await StorageService.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          final requiresAuth =
              error.requestOptions.extra['requiresAuth'] == true;
          if (error.response?.statusCode == 401 && requiresAuth) {
            await StorageService.deleteToken();
            _unauthorizedController.add(null);
          }
          return handler.next(error);
        },
      ),
    );

    return dioInstance;
  }
}
