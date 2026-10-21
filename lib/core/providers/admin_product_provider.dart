import 'package:flutter/foundation.dart';

import '../../models/product_model.dart';
import '../../models/product_status.dart';
import '../../services/admin_service.dart';

class AdminProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts(ProductStatus status) async {
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
    } catch (e) {
      debugPrint(e.toString());
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
