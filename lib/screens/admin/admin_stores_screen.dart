import 'package:flutter/material.dart';

import '../../models/store_model.dart';
import '../../services/admin_service.dart';

class AdminStoresScreen extends StatefulWidget {
  const AdminStoresScreen({super.key});

  @override
  State<AdminStoresScreen> createState() => _AdminStoresScreenState();
}

class _AdminStoresScreenState extends State<AdminStoresScreen> {
  late List<StoreModel> stores;
  String? errorMessage;
  bool isLoading = false;

  Future<void> fetchStores() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      Map<String, dynamic> data = await AdminService.getStores();

      if (data['stores'] != null) {
        setState(() {
          stores = data['stores'] as List<StoreModel>;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = data['message'];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mağazalar')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hata: $errorMessage'),
            ElevatedButton(
              onPressed: fetchStores,
              child: const Text('Yeniden Dene'),
            ),
          ],
        ),
      );
    }

    if (stores.isEmpty) {
      return const Center(child: Text('Henüz mağaza bulunmuyor.'));
    }

    return RefreshIndicator(
      onRefresh: fetchStores,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final StoreModel store = stores[index];
          return ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 8.0),
            childrenPadding: const EdgeInsets.all(8.0),
            leading: _buildLeading(store.status),
            title: Text(store.name),
            subtitle: Text('Satıcı: ${store.vendorFullName}'),
            children: [
              _buildChildRow('ID', store.id),
              const SizedBox(height: 8.0),
              _buildChildRow('Açıklama', store.description),
              const SizedBox(height: 8.0),
              _buildChildRow('E-posta', store.email),
              const SizedBox(height: 8.0),
              _buildChildRow('Telefon', store.phone),
              const SizedBox(height: 8.0),
              _buildChildRow('Adres', store.address),
              const SizedBox(height: 8.0),
              _buildChildRow('Kayıt T.', store.createdAt.toIso8601String()),
              const SizedBox(height: 8.0),
              _buildChildRow('Düzenleme T.', store.updatedAt.toIso8601String()),
            ],
          );
        },
      ),
    );
  }

  Icon _buildLeading(String status) {
    switch (status) {
      case 'ACTIVE':
        return const Icon(Icons.check_box, color: Colors.green);
      case 'PASSIVE':
        return const Icon(Icons.indeterminate_check_box, color: Colors.amber);
      case 'DELETED':
        return const Icon(Icons.delete_rounded, color: Colors.redAccent);
      default:
        return const Icon(Icons.question_mark_rounded, color: Colors.grey);
    }
  }

  Row _buildChildRow(String title, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(flex: 5, child: Text(content, textAlign: TextAlign.justify)),
      ],
    );
  }
}
