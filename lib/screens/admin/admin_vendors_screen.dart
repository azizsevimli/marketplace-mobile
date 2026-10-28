import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/vendor_model.dart';
import '../../models/vendor_status.dart';
import '../../services/admin_service.dart';
import '../../widgets/admin/admin_appbars.dart';
import '../../widgets/admin/error_screen.dart';
import '../../widgets/admin/loading_screen.dart';

class AdminVendorsScreen extends StatefulWidget {
  const AdminVendorsScreen({super.key});

  @override
  State<AdminVendorsScreen> createState() => _AdminVendorsScreenState();
}

class _AdminVendorsScreenState extends State<AdminVendorsScreen> {
  late List<VendorModel> _vendors;
  String? _errorMessage;
  bool _isLoading = false;

  // TODO(001): Provider'a çevirilecek kaydetme ile beraber.
  Future<void> _getVendors() async {
    try {
      setState(() {
        _errorMessage = null;
        _isLoading = true;
      });

      final data = await AdminService.getVendors();

      if (data['vendors'] == null) {
        setState(() {
          _errorMessage = data['message'];
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _vendors = data['vendors'];
        _errorMessage = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getVendors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminScreensAppBar(context: context, title: 'Satıcılar'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading == true) {
      return const LoadingScreen();
    }

    if (_errorMessage != null) {
      return ErrorScreen(errorMessage: _errorMessage!, onPressed: _getVendors);
    }

    return RefreshIndicator(
      onRefresh: _getVendors,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        itemCount: _vendors.length,
        itemBuilder: (context, index) {
          VendorModel vendor = _vendors[index];
          return ListTile(
            leading: _buildLeading(vendor.status),
            title: Text('${vendor.firstName} ${vendor.lastName}'),
            subtitle: Text(vendor.email),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.push('/admin/users/vendors/${vendor.id}'),
          );
        },
      ),
    );
  }

  Icon _buildLeading(VendorStatus status) {
    switch (status) {
      case VendorStatus.pending:
        return const Icon(Icons.pending_outlined, color: Colors.amber);
      case VendorStatus.approved:
        return const Icon(Icons.check_box_outlined, color: Colors.green);
      case VendorStatus.rejected:
        return const Icon(
          Icons.indeterminate_check_box_outlined,
          color: Colors.red,
        );
    }
  }
}
