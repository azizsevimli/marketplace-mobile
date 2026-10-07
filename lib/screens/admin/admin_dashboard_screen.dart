import 'package:flutter/material.dart';

import '../../models/admin_stats_model.dart';
import '../../services/admin_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  AdminStatsModel? _stats;
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _getStats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final data = await AdminService.getDashboardStats();

    if (data?['stats'] != null) {
      setState(() {
        _stats = data?['stats'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = data?['message'];
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace Admin'), centerTitle: true),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hata: $_errorMessage'),
            ElevatedButton(
              onPressed: _getStats,
              child: const Text('Yeniden Dene'),
            ),
          ],
        ),
      );
    }

    if (_stats == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Hata: Veri bulunamadı.'),
            ElevatedButton(
              onPressed: _getStats,
              child: const Text('Yeniden Dene'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            _buildCard(
              title: 'Kullanıcı',
              titleValue: _stats!.users.total,
              subtitles: [
                (title: 'Admin', value: _stats!.users.admin),
                (title: 'Müşteri', value: _stats!.users.customer),
                (title: 'Vendor', value: _stats!.users.vendor),
              ],
              icon: const Icon(Icons.person_outline),
              buttonTitle: 'Kullanıcılar',
              onPressed: () {}, // İlgili sayfayı oluşturunca ekleyeceğim
            ),
            _buildCard(
              title: 'Ürün',
              titleValue: _stats!.products.total,
              subtitles: [
                (title: 'Bekleyen', value: _stats!.products.pending),
                (title: 'Aktif', value: _stats!.products.active),
                (title: 'Pasif', value: _stats!.products.passive),
                (title: 'Ret', value: _stats!.products.rejected),
              ],
              icon: const Icon(Icons.shopping_cart_outlined),
              buttonTitle: 'Ürünler',
              onPressed: () {}, // İlgili sayfayı oluşturunca ekleyeceğim
            ),
            _buildCard(
              title: 'Sipariş',
              titleValue: _stats!.orders.total,
              subtitles: [
                (title: 'Bekleyen', value: _stats!.orders.pending),
                (title: 'Hazırlanıyor', value: _stats!.orders.preparing),
                (title: 'Teslim edilen', value: _stats!.orders.completed),
                (title: 'İptal', value: _stats!.orders.cancelled),
              ],
              icon: const Icon(Icons.receipt_long_outlined),
              buttonTitle: 'Siparişler',
              onPressed: () {}, // İlgili sayfayı oluşturunca ekleyeceğim
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String titleValue,
    required List<({String title, String value})> subtitles,
    required Widget icon,
    required String buttonTitle,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: ListTile(
        leading: icon,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              titleValue,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
          children: [
            const Divider(),
            for (final subtitle in subtitles)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subtitle.title,
                    style: const TextStyle(fontWeight: .bold),
                  ),
                  Text(subtitle.value),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onPressed, child: Text(buttonTitle)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
