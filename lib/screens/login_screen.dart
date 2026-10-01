import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.go('/admin/login');
              },
              icon: Icon(Icons.admin_panel_settings_outlined, size: 24),
              label: Text("Admin"),
            ),
          ],
        ),
      ),
    );
  }
}
