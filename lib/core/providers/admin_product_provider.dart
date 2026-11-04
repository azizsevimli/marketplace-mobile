import 'package:flutter/foundation.dart';

import '../../models/product_model.dart';
import '../../models/product_status.dart';
import '../../services/admin_service.dart';
import '../utils/result.dart';

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

  Future<void> fetchProductsByStatus(ProductStatus status) async {
    _products = [];
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final Result<List<ProductModel>> result =
        await AdminService.getProductsByStatus(status.value);

    switch (result) {
      case Ok<List<ProductModel>>():
        _products = result.value;
      case Error<List<ProductModel>>():
        _errorMessage = result.error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProductDetail(String id) async {
    _product = null;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final Result<ProductModel> result = await AdminService.getProductDetail(id);

    switch (result) {
      case Ok<ProductModel>():
        _product = result.value;
        selectStatus(_product!.status);
      case Error<ProductModel>():
        _errorMessage = result.error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProductStatus(String id, ProductStatus status) async {
    _isUpdating = true;
    _updateErrorMessage = null;
    notifyListeners();

    final Result<ProductModel> result = await AdminService.updateProductStatus(
      id,
      status.value,
    );

    switch (result) {
      case Ok<ProductModel>():
        _product = result.value;
        _isUpdating = false;
        notifyListeners();
        return true;

      case Error<ProductModel>():
        _updateErrorMessage = result.error.toString();
        _isUpdating = false;
        notifyListeners();
        return false;
    }
  }
}
