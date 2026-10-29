import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/providers/admin_users_provider.dart';
// import '../../models/admin_model.dart';
// import '../../services/admin_service.dart';
import '../../widgets/admin/admin_appbars.dart';
import '../../widgets/admin/error_screen.dart';
import '../../widgets/admin/loading_screen.dart';
import '../../widgets/admin/user_expansion_tile.dart';

class AdminAdminsScreen extends StatefulWidget {
  const AdminAdminsScreen({super.key});

  @override
  State<AdminAdminsScreen> createState() => _AdminAdminsScreenState();
}

class _AdminAdminsScreenState extends State<AdminAdminsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminUsersProvider>().fetchAdmins();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminScreensAppBar(context: context, title: 'Adminler'),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    return Consumer<AdminUsersProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading == true) {
          return const LoadingScreen();
        }

        if (provider.errorMessage != null) {
          return ErrorScreen(
            errorMessage: provider.errorMessage!,
            onPressed: provider.fetchAdmins,
          );
        }
        return RefreshIndicator(
          onRefresh: provider.fetchAdmins,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0,
            ),
            itemCount: provider.admins.length,
            itemBuilder: (context, index) {
              final admin = provider.admins[index];

              final createdAt = DateFormat(
                'dd MMMM yyyy - HH.mm (UTC)',
                'tr_TR',
              ).format(admin.createdAt);

              return UserExpansionTile(
                title: '${admin.firstName} ${admin.lastName}',
                subtitle: admin.email,
                rowList: [
                  (rowTitle: 'ID', rowValue: admin.id),
                  (
                    rowTitle: 'Telefon',
                    rowValue: admin.phone ?? 'Kayıtlı değil',
                  ),
                  (rowTitle: 'Kayıt Tarihi', rowValue: createdAt),
                ],
              );
            },
          ),
        );
      },
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => context.push('/admin/users/admins/new'),
      icon: const Icon(Icons.add),
      label: const Text('Yeni Admin'),
    );
  }
}
