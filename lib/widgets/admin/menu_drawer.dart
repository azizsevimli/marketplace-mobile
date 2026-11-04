import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminMenuDrawer extends StatelessWidget {
  AdminMenuDrawer({super.key});

  final List<({String title, String route})> _menuList = [
    (title: 'Kullanıcılar', route: '/admin/users'),
    (title: 'Kategoriler', route: '/admin/categories'),
    (title: 'Mağazalar', route: '/admin/stores'),
    (title: 'Ürünler', route: '/admin/products'),
    (title: 'Siparişler', route: '/admin/orders'),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade300),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'Marketplace',
                style: Theme.of(context).textTheme.headlineMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _menuList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_menuList[index].title),
                  onTap: () => context.push(_menuList[index].route),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
