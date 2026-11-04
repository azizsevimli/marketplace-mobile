import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/utils/result.dart';
import '../../models/user_model.dart';
import '../../services/admin_service.dart';
import '../../widgets/admin/admin_appbars.dart';
import '../../widgets/admin/error_screen.dart';
import '../../widgets/admin/loading_screen.dart';
import '../../widgets/admin/user_expansion_tile.dart';

class AdminCustomersScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  late List<UserModel> _customers;
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _getCustomers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final Result<List<UserModel>> result = await AdminService.getCustomers();

    switch (result) {
      case Ok<List<UserModel>>():
        setState(() {
          _customers = result.value;
          _isLoading = false;
        });
      case Error<List<UserModel>>():
        setState(() {
          _errorMessage = result.error.toString();
          _isLoading = false;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminScreensAppBar(context: context, title: 'Müşteriler'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading == true) {
      return const LoadingScreen();
    }

    if (_errorMessage != null) {
      return ErrorScreen(
        errorMessage: _errorMessage!,
        onPressed: _getCustomers,
      );
    }

    return RefreshIndicator(
      onRefresh: _getCustomers,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          UserModel customer = _customers[index];

          final createdAt = DateFormat(
            'dd MMMM yyyy - HH.mm (UTC)',
            'tr_TR',
          ).format(customer.createdAt);

          final updatedAt = DateFormat(
            'dd MMMM yyyy - HH.mm (UTC)',
            'tr_TR',
          ).format(customer.updatedAt);

          return UserExpansionTile(
            title: '${customer.firstName} ${customer.lastName}',
            subtitle: customer.email,
            rowList: [
              (rowTitle: 'ID', rowValue: customer.id),
              (
                rowTitle: 'Telefon',
                rowValue: customer.phone ?? 'Kayıtlı değil',
              ),
              (rowTitle: 'Kayıt Tarihi', rowValue: createdAt),
              (rowTitle: 'Güncellenme Tarihi', rowValue: updatedAt),
            ],
          );
        },
      ),
    );
  }
}
