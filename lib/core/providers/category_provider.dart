import 'package:flutter/material.dart';

import '../../models/category_model.dart';
import '../../services/admin_service.dart';

class CategoryProvider extends ChangeNotifier {
  // final AdminService _service = AdminService();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isEditing = false;
  bool _isDeleting = false;
  String? _errorMessage;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isEditing => _isEditing;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> data =
          await AdminService.getCategoriesWithSub();

      if (data['categories'] != null) {
        _categories = data['categories'];
      } else {
        _errorMessage = data['message'];
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      _isCreating = false;
      _isEditing = false;
      _isDeleting = false;
      notifyListeners();
    }
  }

  Future<bool> createCategory(String title, String slug) async {
    _isCreating = true;
    notifyListeners();
    try {
      await AdminService.createCategory(title, slug);
      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isCreating = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCategory(String id, String title, String slug) async {
    _isEditing = true;
    notifyListeners();
    try {
      await AdminService.updateCategory(id, title, slug);
      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isEditing = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    _isDeleting = true;
    notifyListeners();
    try {
      await AdminService.deleteCategory(id);
      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = 'Kategori silinemedi.';
      _isDeleting = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createSubcategory(
    String parentId,
    String title,
    String slug,
  ) async {
    _isCreating = true;
    notifyListeners();
    try {
      await AdminService.createSubcategory(parentId, title, slug);
      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isCreating = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSubcategory(
    String id,
    String parentId,
    String title,
    String slug,
  ) async {
    _isEditing = true;
    notifyListeners();
    try {
      await AdminService.updateSubcategory(id, parentId, title, slug);
      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isEditing = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSubcategory(String id) async {
    _isDeleting = true;
    notifyListeners();
    try {
      await AdminService.deleteSubcategory(id);
      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = 'Kategori silinemedi.';
      _isDeleting = false;
      notifyListeners();
      return false;
    }
  }
}
