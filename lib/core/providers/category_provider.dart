import 'package:flutter/material.dart';

import '../../models/category_model.dart';
import '../../services/admin_service.dart';
import '../utils/result.dart';

class CategoryProvider extends ChangeNotifier {
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

    final Result<List<CategoryModel>> result =
        await AdminService.getCategoriesWithSub();

    switch (result) {
      case Ok<List<CategoryModel>>():
        _categories = result.value;
      case Error<List<CategoryModel>>():
        _errorMessage = result.error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createCategory(String title, String slug) async {
    _isCreating = true;
    notifyListeners();

    final Result<bool> result = await AdminService.createCategory(
      title: title,
      slug: slug,
    );

    switch (result) {
      case Ok<bool>():
        _isCreating = false;
        await fetchCategories();
        notifyListeners();
        return result.value;
      case Error<bool>():
        _isCreating = false;
        _errorMessage = result.error.toString();
        notifyListeners();
        return false;
    }
  }

  Future<bool> updateCategory(String id, String title, String slug) async {
    _isEditing = true;
    notifyListeners();

    final Result<bool> result = await AdminService.updateCategory(
      id: id,
      title: title,
      slug: slug,
    );

    switch (result) {
      case Ok<bool>():
        _isEditing = false;
        await fetchCategories();
        notifyListeners();
        return result.value;
      case Error<bool>():
        _isEditing = false;
        _errorMessage = result.error.toString();
        notifyListeners();
        return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    _isDeleting = true;
    notifyListeners();

    final Result<bool> result = await AdminService.deleteCategory(id);

    switch (result) {
      case Ok<bool>():
        _isDeleting = false;
        await fetchCategories();
        notifyListeners();
        return result.value;
      case Error<bool>():
        _isDeleting = false;
        _errorMessage = result.error.toString();
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

    final Result<bool> result = await AdminService.createSubcategory(
      parentId: parentId,
      title: title,
      slug: slug,
    );

    switch (result) {
      case Ok<bool>():
        _isCreating = false;
        await fetchCategories();
        notifyListeners();
        return result.value;
      case Error<bool>():
        _isCreating = false;
        _errorMessage = result.error.toString();
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

    final Result<bool> result = await AdminService.updateSubcategory(
      id: id,
      parentId: parentId,
      title: title,
      slug: slug,
    );

    switch (result) {
      case Ok<bool>():
        _isEditing = false;
        await fetchCategories();
        notifyListeners();
        return result.value;
      case Error<bool>():
        _isEditing = false;
        _errorMessage = result.error.toString();
        notifyListeners();
        return false;
    }
  }

  Future<bool> deleteSubcategory(String id) async {
    _isDeleting = true;
    notifyListeners();

    final Result<bool> result = await AdminService.deleteSubcategory(id);

    switch (result) {
      case Ok<bool>():
        _isDeleting = false;
        await fetchCategories();
        notifyListeners();
        return result.value;
      case Error<bool>():
        _isDeleting = false;
        _errorMessage = result.error.toString();
        notifyListeners();
        return false;
    }
  }
}
