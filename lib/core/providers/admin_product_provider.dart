import 'package:flutter/foundation.dart';

import '../../models/product_model.dart';
import '../../models/product_status.dart';
import '../../services/admin_service.dart';

class AdminProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  ProductModel? _product;
  ProductStatus? _selectedStatus;
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _errorMessage;
  String? _updateErrorMessage;

  List<ProductModel> get products => _products;
  ProductModel? get product => _product;
  ProductStatus? get selectedStatus => _selectedStatus;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;
  String? get updateErrorMessage => _updateErrorMessage;

  void selectStatus(ProductStatus? status) {
    _selectedStatus = status;
  }

  Future<void> fetchProducts(ProductStatus status) async {
    _products = [];
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> data = await AdminService.getProductsByStatus(
        status.value,
      );
      if (data['products'] != null) {
        _products = data['products'];
      } else {
        _errorMessage = data['message'];
      }
    } catch (e, s) {
      debugPrint('$e\n$s');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductDetail(String id) async {
    _product = null;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> data = await AdminService.getProductDetail(id);

      if (data['product'] != null) {
        _product = data['product'];
        selectStatus(_product!.status);
      } else {
        _errorMessage = data['message'];
      }
    } catch (e, s) {
      debugPrint('$e\n$s');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProductStatus(String id, ProductStatus status) async {
    _isUpdating = true;
    _updateErrorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> data = await AdminService.updateProductStatus(
        id,
        status.value,
      );

      if (data['product'] != null) {
        _product = data['product'];
        return true;
      } else {
        _updateErrorMessage = data['message'];
        return false;
      }
    } catch (e, s) {
      debugPrint('$e\n$s');
      _updateErrorMessage = e.toString();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
}
