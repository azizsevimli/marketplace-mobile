import 'package:flutter/material.dart';
import 'package:marketplace_mobile/widgets/admin/loading_screen.dart';

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
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      Map<String, dynamic> data = await AdminService.getStores();

      if (data['stores'] != null) {
        setState(() {
          _stores = data['stores'] as List<StoreModel>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = data['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _errorMessage = e.toString();
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
