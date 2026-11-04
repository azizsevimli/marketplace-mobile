import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/providers/admin_users_provider.dart';
import '../../models/vendor_model.dart';
import '../../models/vendor_status.dart';
// import '../../services/admin_service.dart';
import '../../widgets/admin/admin_appbars.dart';
import '../../widgets/admin/error_screen.dart';
import '../../widgets/admin/loading_screen.dart';

class AdminVendorsScreen extends StatefulWidget {
  const AdminVendorsScreen({super.key});

  @override
  State<AdminVendorsScreen> createState() => _AdminVendorsScreenState();
}

class _AdminVendorsScreenState extends State<AdminVendorsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminUsersProvider>().fetchVendors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminScreensAppBar(context: context, title: 'Satıcılar'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Consumer<AdminUsersProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const LoadingScreen();
        }

        if (provider.errorMessage != null) {
          return ErrorScreen(
            errorMessage: provider.errorMessage!,
            onPressed: provider.fetchVendors,
          );
        }

        return RefreshIndicator(
          onRefresh: provider.fetchVendors,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0,
            ),
            itemCount: provider.vendors.length,
            itemBuilder: (context, index) {
              VendorModel vendor = provider.vendors[index];
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
      },
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
