import 'package:flutter/material.dart';
import 'package:marketplace_mobile/widgets/admin/loading_screen.dart';

import '../../core/utils/result.dart';
import '../../models/store_model.dart';
import '../../services/admin_service.dart';
import '../../widgets/admin/admin_appbars.dart';
import '../../widgets/admin/error_screen.dart';
import '../../widgets/admin/store_expansion_tile.dart';

class AdminStoresScreen extends StatefulWidget {
  const AdminStoresScreen({super.key});

  @override
  State<AdminStoresScreen> createState() => _AdminStoresScreenState();
}

class _AdminStoresScreenState extends State<AdminStoresScreen> {
  late List<StoreModel> _stores;
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _fetchStores() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final Result<List<StoreModel>> result = await AdminService.getStores();

    switch (result) {
      case Ok<List<StoreModel>>():
        setState(() {
          _stores = result.value;
          _isLoading = false;
        });
      case Error<List<StoreModel>>():
        setState(() {
          _errorMessage = result.error.toString();
          _isLoading = false;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminScreensAppBar(context: context, title: 'Mağazalar'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingScreen();
    }

    if (_errorMessage != null) {
      return ErrorScreen(errorMessage: _errorMessage!, onPressed: _fetchStores);
    }

    if (_stores.isEmpty) {
      return const Center(child: Text('Henüz mağaza bulunmuyor.'));
    }

    return RefreshIndicator(
      onRefresh: _fetchStores,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        itemCount: _stores.length,
        itemBuilder: (context, index) {
          final StoreModel store = _stores[index];
          return StoreExpansionTile(store: store);
        },
      ),
    );
  }
}
