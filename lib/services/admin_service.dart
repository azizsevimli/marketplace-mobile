import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../core/utils/result.dart';
import '../models/admin_model.dart';
import '../models/admin_stats_model.dart';
import '../models/category_model.dart';
import '../models/order_item_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import '../models/user_model.dart';
import '../models/vendor_model.dart';

class AdminService {
  static final _dio = DioClient.dio;
  static Options get _auth => Options(extra: {'requiresAuth': true});

  static Future<Result<String>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/admin/users/admins/new',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phone': phone,
          'password': password,
        },
        options: _auth,
      );

      if (response.data['success']) {
        final String userId = response.data['userId'];

        return Result.ok(userId);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<AdminStatsModel>> getDashboardStats() async {
    try {
      final response = await _dio.get('/admin/dashboard', options: _auth);
      if (response.data['success']) {
        final AdminStatsModel stats = AdminStatsModel.fromJson(
          response.data['stats'],
        );
        return Result.ok(stats);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<List<AdminModel>>> getAdmins() async {
    try {
      final response = await _dio.get('/admin/users/admins', options: _auth);

      if (response.data['success']) {
        final List responseList = response.data['admins'];

        final List<AdminModel> admins = responseList
            .map((i) => AdminModel.fromJson(Map<String, dynamic>.from(i)))
            .toList();

        return Result.ok(admins);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<List<UserModel>>> getCustomers() async {
    try {
      final response = await _dio.get('/admin/users/customers', options: _auth);

      if (response.data['success']) {
        final List responseList = response.data['customers'];

        final List<UserModel> customers = responseList
            .map((i) => UserModel.fromJson(Map<String, dynamic>.from(i)))
            .toList();

        return Result.ok(customers);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<List<VendorModel>>> getVendors() async {
    try {
      final response = await _dio.get('/admin/users/vendors', options: _auth);

      if (response.data['success']) {
        final List responseList = response.data['vendors'];

        final List<VendorModel> vendors = responseList
            .map((i) => VendorModel.fromJson(Map<String, dynamic>.from(i)))
            .toList();

        return Result.ok(vendors);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<VendorModel>> getVendorById(String id) async {
    try {
      final response = await _dio.get(
        '/admin/users/vendors/$id',
        options: _auth,
      );

      if (response.data['success']) {
        final VendorModel vendor = VendorModel.fromJson(
          response.data['vendor'],
        );

        return Result.ok(vendor);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<bool>> updateVendorStatus(
    String id,
    String status,
    String? rejectedMessage,
  ) async {
    try {
      final response = await _dio.post(
        '/admin/users/vendors/$id',
        data: {'status': status, 'rejectedMessage': rejectedMessage},
        options: _auth,
      );

      if (response.data['success']) {
        return Result.ok(true);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<List<CategoryModel>>> getCategoriesWithSub() async {
    try {
      final response = await _dio.get('/admin/categories', options: _auth);

      if (response.data['success']) {
        final List<dynamic> responseList = response.data['categories'];

        final List<CategoryModel> categories = responseList
            .map((i) => CategoryModel.fromJson(i as Map<String, dynamic>))
            .toList();

        return Result.ok(categories);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<bool>> createCategory({
    required String title,
    required String slug,
  }) async {
    try {
      final response = await _dio.post(
        '/category',
        data: {'title': title, 'slug': slug},
        options: _auth,
      );

      if (response.data['success']) {
        return Result.ok(true);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<bool>> updateCategory({
    required String id,
    required String title,
    required String slug,
  }) async {
    try {
      final response = await _dio.patch(
        '/category/$id',
        data: {'title': title, 'slug': slug},
        options: _auth,
      );

      if (response.data['success']) {
        return Result.ok(true);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<bool>> deleteCategory(String id) async {
    try {
      final response = await _dio.delete('/category/$id', options: _auth);

      if (response.data['success']) {
        return Result.ok(true);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<bool>> createSubcategory({
    required String parentId,
    required String title,
    required String slug,
  }) async {
    try {
      final response = await _dio.post(
        '/subcategory',
        data: {'parentId': parentId, 'title': title, 'slug': slug},
        options: _auth,
      );

      if (response.data['success']) {
        return Result.ok(true);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<bool>> updateSubcategory({
    required String id,
    required String parentId,
    required String title,
    required String slug,
  }) async {
    try {
      final response = await _dio.patch(
        '/subcategory/$id',
        data: {'parentId': parentId, 'title': title, 'slug': slug},
        options: _auth,
      );

      if (response.data['success']) {
        return Result.ok(true);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<bool>> deleteSubcategory(String id) async {
    try {
      final response = await _dio.delete('/subcategory/$id', options: _auth);

      if (response.data['success']) {
        return Result.ok(true);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<List<StoreModel>>> getStores() async {
    try {
      final response = await _dio.get('/admin/stores', options: _auth);

      if (response.data['success']) {
        final List<dynamic> responseList = response.data['result'];

        final List<StoreModel> stores = responseList
            .map((i) => StoreModel.fromJson(i as Map<String, dynamic>))
            .toList();

        return Result.ok(stores);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<List<OrderModel>>> getOrders() async {
    try {
      final response = await _dio.get('/admin/orders', options: _auth);

      if (response.data['success']) {
        final List<dynamic> responseList = response.data['result'];

        final List<OrderModel> orders = responseList
            .map((i) => OrderModel.fromJson(i as Map<String, dynamic>))
            .toList();
        return Result.ok(orders);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<List<OrderItemModel>>> getOrderItemsByOrderId(
    String id,
  ) async {
    try {
      final response = await _dio.get('/admin/order-items/$id', options: _auth);

      if (response.data['success']) {
        final List<dynamic> responseList = response.data['result'];

        final List<OrderItemModel> orderItems = responseList
            .map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>))
            .toList();
        return Result.ok(orderItems);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<List<ProductModel>>> getProductsByStatus(
    String status,
  ) async {
    try {
      final response = await _dio.get(
        '/admin/products?status=$status',
        options: _auth,
      );

      if (response.data['success']) {
        final List<dynamic> responseList = response.data['result'];

        final List<ProductModel> products = responseList
            .map((i) => ProductModel.fromJson(i as Map<String, dynamic>))
            .toList();
        return Result.ok(products);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<ProductModel>> getProductDetail(String id) async {
    try {
      final response = await _dio.get('/admin/products/$id', options: _auth);

      if (response.data['success']) {
        final ProductModel product = ProductModel.fromJson(
          response.data['result'],
        );

        return Result.ok(product);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<ProductModel>> updateProductStatus(
    String id,
    String status,
  ) async {
    try {
      final response = await _dio.patch(
        '/admin/products/$id',
        data: {'status': status},
        options: _auth,
      );

      if (response.data['success']) {
        final ProductModel product = ProductModel.fromJson(
          response.data['result'],
        );

        return Result.ok(product);
      } else {
        return Result.error(Exception('Hatalı sonuç'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }
}
