import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/network/dio_client.dart';
import '../core/storage/secure_storage.dart';
import '../models/admin_model.dart';
import '../models/admin_stats_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import '../models/vendor_model.dart';

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

  static Future<Map<String, dynamic>> getCustomers() async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.get(
          '/admin/users/customers',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          return {'message': response.data['message'], 'customers': null};
        }

        final List responseList = response.data['customers'];

        final List<UserModel> list = responseList
            .map((i) => UserModel.fromJson(Map<String, dynamic>.from(i)))
            .toList();

        return {'message': response.data['message'], 'customers': list};
      } else {
        await StorageService.deleteToken();
        return {
          'message': 'Yetkisiz Erişim (Token bulunmuyor)',
          'customers': null,
        };
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return {'message': e.message, 'customers': null};
    }
  }

  static Future<Map<String, dynamic>> getVendors() async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.get(
          '/admin/users/vendors',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          return {'message': response.data['message'], 'vendors': null};
        }

        final List responseList = response.data['vendors'];

        final List<VendorModel> list = responseList
            .map((i) => VendorModel.fromJson(Map<String, dynamic>.from(i)))
            .toList();

        return {'message': response.data['message'], 'vendors': list};
      } else {
        await StorageService.deleteToken();
        return {
          'message': 'Yetkisiz Erişim (Token bulunmuyor)',
          'vendors': null,
        };
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return {'message': e.message, 'vendors': null};
    }
  }

  static Future<Map<String, dynamic>> getVendorById(String id) async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.get(
          '/admin/users/vendors/$id',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          return {'message': response.data['message'], 'vendor': null};
        }

        final VendorModel vendor = VendorModel.fromJson(
          response.data['vendor'],
        );

        return {'message': response.data['message'], 'vendor': vendor};
      } else {
        await StorageService.deleteToken();
        return {
          'message': 'Yetkisiz Erişim (Token bulunmuyor)',
          'vendor': null,
        };
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return {'message': e.message, 'vendor': null};
    }
  }

  static Future<String> updateVendorStatus(
    String id,
    String status,
    String? rejectedMessage,
  ) async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.post(
          '/admin/users/vendors/$id',
          data: {'status': status, 'rejectedMessage': rejectedMessage},
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          return response.data['message'];
        }

        return response.data['message'];
      } else {
        await StorageService.deleteToken();
        return 'Yetkisiz Erişim (Token bulunmuyor)';
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return e.message.toString();
    }
  }

  static Future<Map<String, dynamic>> getCategoriesWithSub() async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.get(
          '/admin/categories',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          return {'message': response.data['message'], 'categories': null};
        }

        final List<dynamic> responseList =
            response.data['categories'] as List<dynamic>;

        final List<CategoryModel> categories = responseList
            .map((i) => CategoryModel.fromJson(i as Map<String, dynamic>))
            .toList();

        return {'message': response.data['message'], 'categories': categories};
      } else {
        await StorageService.deleteToken();
        return {
          'message': 'Yetkisiz Erişim (Token bulunmuyor)',
          'categories': null,
        };
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return {'message': e.message, 'categories': null};
    }
  }

  static Future<String> createCategory(String title, String slug) async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.post(
          '/category',
          data: {'title': title, 'slug': slug},
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          throw response.data['message'];
          // return response.data['message'];
        }

        return response.data['message'];
      } else {
        await StorageService.deleteToken();
        throw 'Yetkisiz Erişim (Token bulunmuyor)';
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return e.message.toString();
    }
  }

  static Future<String> updateCategory(
    String id,
    String title,
    String slug,
  ) async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.patch(
          '/category/$id',
          data: {'title': title, 'slug': slug},
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          throw response.data['message'];
          // return response.data['message'];
        }

        return response.data['message'];
      } else {
        await StorageService.deleteToken();
        throw 'Yetkisiz Erişim (Token bulunmuyor)';
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return e.message.toString();
    }
  }

  static Future<String> deleteCategory(String id) async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.delete(
          '/category/$id',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          throw response.data['message'];
          // return response.data['message'];
        }

        return response.data['message'];
      } else {
        await StorageService.deleteToken();
        throw 'Yetkisiz Erişim (Token bulunmuyor)';
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return e.message.toString();
    }
  }

  static Future<String> createSubcategory(
    String parentId,
    String title,
    String slug,
  ) async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.post(
          '/subcategory',
          data: {'parentId': parentId, 'title': title, 'slug': slug},
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          throw response.data['message'];
          // return response.data['message'];
        }

        return response.data['message'];
      } else {
        await StorageService.deleteToken();
        throw 'Yetkisiz Erişim (Token bulunmuyor)';
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return e.message.toString();
    }
  }

  static Future<String> updateSubcategory(
    String id,
    String parentId,
    String title,
    String slug,
  ) async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.patch(
          '/subcategory/$id',
          data: {'parentId': parentId, 'title': title, 'slug': slug},
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          throw response.data['message'];
          // return response.data['message'];
        }

        return response.data['message'];
      } else {
        await StorageService.deleteToken();
        throw 'Yetkisiz Erişim (Token bulunmuyor)';
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return e.message.toString();
    }
  }

  static Future<String> deleteSubcategory(String id) async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.delete(
          '/subcategory/$id',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.data['success'] != true) {
          throw response.data['message'];
          // return response.data['message'];
        }

        return response.data['message'];
      } else {
        await StorageService.deleteToken();
        throw 'Yetkisiz Erişim (Token bulunmuyor)';
      }
    } on DioException catch (e) {
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('Hata [Status]: ${e.response?.statusCode}');
      debugPrint('Hata [Body]: ${e.response?.data}');
      return e.message.toString();
    }
  }
}
