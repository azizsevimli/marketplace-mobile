import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/admin_model.dart';
import '../../services/admin_service.dart';

class AdminAdminsScreen extends StatefulWidget {
  const AdminAdminsScreen({super.key});

  @override
  State<AdminAdminsScreen> createState() => _AdminAdminsScreenState();
}

class _AdminAdminsScreenState extends State<AdminAdminsScreen> {
  late List<AdminModel> _admins;
  String? errorMessage;
  bool isLoading = false;

  Future<void> getAdmins() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final data = await AdminService.getAdmins();

      if (data['admins'] == null) {
        setState(() {
          errorMessage = data['message'];
          isLoading = false;
        });
        return;
      }

      setState(() {
        _admins = data['admins'];
        errorMessage = null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAdmins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adminler'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    if (isLoading == true) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!),
            ElevatedButton(
              onPressed: getAdmins,
              child: const Text('Yeniden dene'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      itemCount: _admins.length,
      itemBuilder: (context, index) {
        final admin = _admins[index];
        return ExpansionTile(
          childrenPadding: const EdgeInsets.all(8.0),
          title: Text('${admin.firstName} ${admin.lastName}'),
          subtitle: Text(admin.email),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(admin.id),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Telefon',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(admin.phone != null ? admin.phone! : 'Kayıtlı değil'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Oluşturulma Tarihi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(admin.createdAt.toString()),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => context.push('/admin/users/admins/new'),
      icon: const Icon(Icons.add),
      label: const Text('Yeni Admin'),
    );
  }
}
