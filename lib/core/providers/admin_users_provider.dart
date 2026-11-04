import 'package:flutter/foundation.dart';

import '../../models/admin_model.dart';
import '../../models/vendor_model.dart';
import '../../models/vendor_status.dart';
import '../../services/admin_service.dart';
import '../utils/result.dart';

class AdminUsersProvider extends ChangeNotifier {
  List<AdminModel> _admins = [];
  List<VendorModel> _vendors = [];
  VendorModel? _vendor;
  String? _newAdminId;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isRegistration = false;
  bool _isUpdating = false;

  List<AdminModel> get admins => _admins;
  List<VendorModel> get vendors => _vendors;
  VendorModel? get vendor => _vendor;
  String? get newAdminId => _newAdminId;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isRegistration => _isRegistration;
  bool get isUpdating => _isUpdating;

  Future<void> fetchAdmins() async {
    _isLoading = true;
    _errorMessage = null;
    _admins = [];
    notifyListeners();

    final result = await AdminService.getAdmins();

    switch (result) {
      case Ok<List<AdminModel>>():
        _admins = result.value;
      case Error<List<AdminModel>>():
        _errorMessage = result.error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registerAdmin(Map<String, dynamic> data) async {
    _isRegistration = true;
    _newAdminId = null;
    _errorMessage = null;
    notifyListeners();

    final result = await AdminService.register(
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      phone: data['phone'],
      password: data['password'],
    );

    switch (result) {
      case Ok<String>():
        _newAdminId = result.value;
      case Error<String>():
        _errorMessage = result.error.toString();
    }

    _isRegistration = false;
    fetchAdmins();
    notifyListeners();
  }

  Future<void> fetchVendors() async {
    _isLoading = true;
    _errorMessage = null;
    _vendors = [];
    notifyListeners();

    final Result<List<VendorModel>> result = await AdminService.getVendors();

    switch (result) {
      case Ok<List<VendorModel>>():
        _vendors = result.value;
      case Error<List<VendorModel>>():
        _errorMessage = result.error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> fetchVendor(String id) async {
    _isLoading = true;
    _errorMessage = null;
    _vendor = null;
    notifyListeners();

    final Result<VendorModel> result = await AdminService.getVendorById(id);

    switch (result) {
      case Ok<VendorModel>():
        _vendor = result.value;
        _isLoading = false;
        notifyListeners();
        return true;
      case Error<VendorModel>():
        _errorMessage = result.error.toString();
        _isLoading = false;
        notifyListeners();
        return false;
    }
  }

  Future<bool> updateVendorStatus(
    String id,
    VendorStatus status,
    String? rejectedMessage,
  ) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    final Result<bool> result = await AdminService.updateVendorStatus(
      id,
      status.value,
      rejectedMessage,
    );

    switch (result) {
      case Ok<bool>():
        _isUpdating = false;
        fetchVendors();
        notifyListeners();
        return result.value;
      case Error<bool>():
        _errorMessage = result.error.toString();
        _isUpdating = false;
        fetchVendors();
        notifyListeners();
        return false;
    }
  }
}
