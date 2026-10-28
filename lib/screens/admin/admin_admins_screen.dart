import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/admin_model.dart';
import '../../services/admin_service.dart';
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
  late List<AdminModel> _admins;
  String? _errorMessage;
  bool _isLoading = false;

  // TODO(001): Provider'a çevirilecek kaydetme ile beraber.
  Future<void> _getAdmins() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await AdminService.getAdmins();

      if (data['admins'] == null) {
        setState(() {
          _errorMessage = data['message'];
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _admins = data['admins'];
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
    _getAdmins();
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
    if (_isLoading == true) {
      return const LoadingScreen();
    }

    if (_errorMessage != null) {
      return ErrorScreen(errorMessage: _errorMessage!, onPressed: _getAdmins);
    }

    return RefreshIndicator(
      onRefresh: _getAdmins,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        itemCount: _admins.length,
        itemBuilder: (context, index) {
          final admin = _admins[index];

          final createdAt = DateFormat(
            'dd MMMM yyyy - HH.mm (UTC)',
            'tr_TR',
          ).format(admin.createdAt);

          return UserExpansionTile(
            title: '${admin.firstName} ${admin.lastName}',
            subtitle: admin.email,
            rowList: [
              (rowTitle: 'ID', rowValue: admin.id),
              (rowTitle: 'Telefon', rowValue: admin.phone ?? 'Kayıtlı değil'),
              (rowTitle: 'Kayıt Tarihi', rowValue: createdAt),
            ],
          );
        },
      ),
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
