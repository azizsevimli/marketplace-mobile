import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/vendor_model.dart';
import '../../models/vendor_status.dart';
import '../../services/admin_service.dart';
import '../../widgets/admin/admin_appbars.dart';
import '../../widgets/admin/error_screen.dart';
import '../../widgets/admin/loading_screen.dart';
import '../../widgets/admin/status_dropdown.dart';
import '../../widgets/admin/vendor_detail_card.dart';

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
  late VendorStatus _status;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isUpdating = false;

  Future<void> _getVendorDetail() async {
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
        _isUpdating = true;
      });

      String message = '';

      if (_status != VendorStatus.rejected) {
        message = await AdminService.updateVendorStatus(
          vendorId,
          _status.value,
          null,
        );
      } else {
        message = await AdminService.updateVendorStatus(
          vendorId,
          _status.value,
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
    _getVendorDetail();
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminScreensAppBar(context: context, title: 'Satıcı Detay'),
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
        onPressed: _getVendorDetail,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 16.0,
        children: [
          VendorDetailCard(vendor: _vendor),
          StatusDropdown(
            onSelected: (value) => setState(() {
              _status = value!;
            }),
            selectedStatus: _status,
            statusList: VendorStatus.entries,
          ),
          if (_status == VendorStatus.rejected)
            TextField(
              controller: textController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                label: Text('Reddedilme Nedeni'),
              ),
            ),

          ElevatedButton(
            onPressed: updateVendorStatus,
            child: _isUpdating
                ? const CircularProgressIndicator()
                : const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
