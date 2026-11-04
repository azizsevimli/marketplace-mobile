import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  static final List<({String title, String route})> _list = [
    (title: 'Admin', route: '/admin/users/admins'),
    (title: 'Müşteri', route: '/admin/users/customers'),
    (title: 'Vendor', route: '/admin/users/vendors'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        title: const Text('Kullanıcılar'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: ListView.separated(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_list[index].title),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.push(_list[index].route),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }
}
