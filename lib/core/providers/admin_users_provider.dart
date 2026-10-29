import 'package:flutter/foundation.dart';

import '../../models/admin_model.dart';
import '../../models/vendor_model.dart';
import '../../models/vendor_status.dart';
import '../../services/admin_service.dart';

class AdminUsersProvider extends ChangeNotifier {
  List<AdminModel> _admins = [];
  List<VendorModel> _vendors = [];
  VendorModel? _vendor;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isRegistration = false;
  bool _isUpdating = false;

  List<AdminModel> get admins => _admins;
  List<VendorModel> get vendors => _vendors;
  VendorModel? get vendor => _vendor;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isRegistration => _isRegistration;
  bool get isUpdating => _isUpdating;

  Future<void> fetchAdmins() async {
    _isLoading = true;
    _errorMessage = null;
    _admins = [];
    notifyListeners();

    try {
      final result = await AdminService.getAdmins();

      if (result['admins'] != null) {
        _admins = result['admins'];
      } else {
        _errorMessage = result['message'];
      }
    } catch (e, s) {
      debugPrint('$e \n $s');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerAdmin(Map<String, dynamic> data) async {
    _isRegistration = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await AdminService.register(
        firstName: data['firstName'],
        lastName: data['lastName'],
        email: data['email'],
        phone: data['phone'],
        password: data['password'],
      );

      if (result['userId'] != null) {
        return true;
      } else {
        _errorMessage = result['message'];
        return false;
      }
    } catch (e, s) {
      debugPrint('$e \n $s');
      _errorMessage = e.toString();
      return false;
    } finally {
      _isRegistration = false;
      fetchAdmins();
      notifyListeners();
    }
  }

  Future<void> fetchVendors() async {
    _isLoading = true;
    _errorMessage = null;
    _vendors = [];
    notifyListeners();

    try {
      final result = await AdminService.getVendors();

      if (result['vendors'] != null) {
        _vendors = result['vendors'];
      } else {
        _errorMessage = result['message'];
      }
    } catch (e, s) {
      debugPrint('$e \n $s');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> fetchVendor(String id) async {
    _isLoading = true;
    _errorMessage = null;
    _vendor = null;
    notifyListeners();

    try {
      final result = await AdminService.getVendorById(id);

      if (result['vendor'] != null) {
        _vendor = result['vendor'];
        return true;
      } else {
        _errorMessage = result['message'];
        return false;
      }
    } catch (e, s) {
      debugPrint('$e \n $s');
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
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

    try {
      final result = await AdminService.updateVendorStatus(
        id,
        status.value,
        rejectedMessage,
      );

      if (result['success']) {
        return true;
      } else {
        _errorMessage = result['message'];
        return false;
      }
    } catch (e, s) {
      debugPrint('$e \n $s');
      _errorMessage = e.toString();
      return false;
    } finally {
      _isUpdating = false;
      fetchVendors();
      notifyListeners();
    }
  }
}
