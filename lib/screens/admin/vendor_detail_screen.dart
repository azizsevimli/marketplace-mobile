import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/vendor_model.dart';
import '../../services/admin_service.dart';

class VendorDetailScreen extends StatefulWidget {
  final String id;
  const VendorDetailScreen({super.key, required this.id});

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  String get vendorId => widget.id;

  final TextEditingController textController = TextEditingController();

  late VendorModel _vendor;
  late String _status;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isUpdating = false;

  Future<void> getVendorDetail() async {
    try {
      setState(() {
        _errorMessage = null;
        _isLoading = true;
      });

      final data = await AdminService.getVendorById(vendorId);

      if (data['vendor'] == null) {
        setState(() {
          _errorMessage = data['message'];
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _vendor = data['vendor'];
        _status = _vendor.status;
        textController.text = _vendor.rejectedMessage != null
            ? _vendor.rejectedMessage!
            : '';
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

  Future<void> updateVendorStatus() async {
    try {
      setState(() {
        _isUpdating = false;
      });

      late String message;

      if (textController.text.trim() == '') {
        message = await AdminService.updateVendorStatus(
          vendorId,
          _status,
          null,
        );
      } else {
        message = await AdminService.updateVendorStatus(
          vendorId,
          _status,
          textController.text.trim(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

      setState(() {
        _isUpdating = false;
      });

      context.pop();
    } catch (e) {
      setState(() {
        _isUpdating = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getVendorDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Satıcı Detay')),
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
              onPressed: getVendorDetail,
              child: const Text('Yeniden dene'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 16.0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  Text('ID'),
                  Text('İsim'),
                  Text('Soyisim'),
                  Text('E-posta'),
                  Text('Telefon'),
                  Text('Kayıt Tarihi'),
                  Text('Güncelleme Tarihi'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  Text(': ${_vendor.id}'),
                  Text(': ${_vendor.firstName}'),
                  Text(': ${_vendor.lastName}'),
                  Text(': ${_vendor.email}'),
                  Text(
                    _vendor.phone != null
                        ? ': ${_vendor.phone!}'
                        : ': Kayıtlı değil',
                  ),
                  Text(': ${_vendor.createdAt.toIso8601String()}'),
                  Text(': ${_vendor.updatedAt.toIso8601String()}'),
                ],
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Durum'),
              DropdownMenu<String>(
                initialSelection: _status,
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: 'PENDING', label: 'Bekliyor'),
                  DropdownMenuEntry(value: 'APPROVED', label: 'Onayla'),
                  DropdownMenuEntry(value: 'REJECTED', label: 'Ret'),
                ],
                onSelected: (value) => setState(() => _status = value!),
              ),
            ],
          ),

          if (_status == 'REJECTED') ...[
            TextField(
              controller: textController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(label: Text('Ret Nedeni')),
            ),
          ],

          ElevatedButton(
            onPressed: updateVendorStatus,
            child: _isUpdating ? CircularProgressIndicator() : Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
