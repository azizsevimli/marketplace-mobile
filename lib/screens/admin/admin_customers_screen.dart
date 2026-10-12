import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/admin_service.dart';

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
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await AdminService.getCustomers();

      if (data['customers'] == null) {
        setState(() {
          _errorMessage = data['message'];
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _customers = data['customers'];
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
    _getCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: _buildBody());
  }

  Widget _buildBody() {
    if (_isLoading == true) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            ElevatedButton(
              onPressed: _getCustomers,
              child: const Text('Yeniden dene'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      itemCount: _customers.length,
      itemBuilder: (context, index) {
        UserModel customer = _customers[index];
        return ExpansionTile(
          title: Text('${customer.firstName} ${customer.lastName}'),
          subtitle: Text(customer.email),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(customer.id),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Telefon',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  customer.phone != null ? customer.phone! : 'Kayıtlı değil',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Oluşturulma Tarihi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(customer.createdAt.toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Güncelleme Tarihi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(customer.updatedAt.toString()),
              ],
            ),
          ],
        );
      },
    );
  }
}
