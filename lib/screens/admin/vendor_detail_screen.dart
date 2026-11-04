import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/providers/admin_users_provider.dart';
import '../../models/vendor_status.dart';
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
  VendorStatus? selectedStatus;

  void changeStatus(VendorStatus? value) {
    setState(() {
      selectedStatus = value;
      textController.text = '';
    });
  }

  Future<void> _load() async {
    final provider = context.read<AdminUsersProvider>();
    final ok = await provider.fetchVendor(vendorId);
    if (!mounted || !ok) return;

    final vendor = provider.vendor!;
    setState(() {
      selectedStatus = vendor.status;
      textController.text = vendor.rejectedMessage ?? '';
    });
  }

  Future<void> updateVendor(
    AdminUsersProvider provider,
    String id,
    VendorStatus status,
    String rejectedMessage,
  ) async {
    bool result = false;

    if (status != VendorStatus.rejected) {
      result = await provider.updateVendorStatus(id, status, null);
    } else {
      result = await provider.updateVendorStatus(id, status, rejectedMessage);
    }

    if (!mounted) return;
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Satıcı durumu güncellendi.')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminScreensAppBar(context: context, title: 'Satıcı Detay'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Consumer<AdminUsersProvider>(
      builder: (context, value, child) {
        if (value.isLoading) {
          return const LoadingScreen();
        }

        if (value.errorMessage != null) {
          return ErrorScreen(
            errorMessage: value.errorMessage!,
            onPressed: () => _load(),
          );
        }

        if (value.vendor == null) {
          return const Center(child: Text('Satıcı bilgileri bulunamadı.'));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 16.0,
            children: [
              VendorDetailCard(vendor: value.vendor!),
              StatusDropdown(
                onSelected: changeStatus,
                selectedStatus: selectedStatus ?? value.vendor!.status,
                statusList: VendorStatus.entries,
              ),

              if (selectedStatus == VendorStatus.rejected)
                TextField(
                  controller: textController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    label: Text('Reddedilme Nedeni'),
                  ),
                ),

              ElevatedButton(
                onPressed: (value.isUpdating || selectedStatus == null)
                    ? null
                    : () => updateVendor(
                        value,
                        vendorId,
                        selectedStatus!,
                        textController.text.trim(),
                      ),
                child: value.isUpdating
                    ? const CircularProgressIndicator()
                    : const Text('Kaydet'),
              ),
            ],
          ),
        );
      },
    );
  }
}
