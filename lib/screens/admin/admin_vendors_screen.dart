import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/vendor_model.dart';
import '../../services/admin_service.dart';

class AdminVendorsScreen extends StatefulWidget {
  const AdminVendorsScreen({super.key});

  @override
  State<AdminVendorsScreen> createState() => _AdminVendorsScreenState();
}

class _AdminVendorsScreenState extends State<AdminVendorsScreen> {
  late List<VendorModel> _vendors;
  String? _errorMessage;
  bool _isLoading = false;

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
      appBar: AppBar(title: Text('Satıcılar')),
      body: _buildBody(),
    );
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
              onPressed: _getVendors,
              child: const Text('Yeniden dene'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      itemCount: _vendors.length,
      itemBuilder: (context, index) {
        VendorModel vendor = _vendors[index];
        String status = vendor.status;
        return ListTile(
          leading: status == 'PENDING'
              ? Icon(Icons.pending_outlined, color: Colors.amber)
              : status == 'APPROVED'
              ? Icon(Icons.check_box_outlined, color: Colors.green)
              : status == 'REJECTED'
              ? Icon(Icons.indeterminate_check_box_outlined, color: Colors.red)
              : Icon(Icons.warning_amber_rounded, color: Colors.blue),
          title: Text('${vendor.firstName} ${vendor.lastName}'),
          subtitle: Text(vendor.email),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            context.push(
              '/admin/users/vendors/${vendor.id}',
            ); // Satıcı onaylama ekranına yönlendirilecek
          },
        );
      },
    );
  }
}
