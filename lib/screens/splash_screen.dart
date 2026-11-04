import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/utils/result.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _checkUserStatus({required BuildContext context}) async {
    final Result<UserModel> result = await AuthService.checkUser();

    if (!context.mounted) return;

    switch (result) {
      case Ok<UserModel>():
        if (result.value.role == 'ADMIN') {
          context.go('/admin/dashboard');
        } else if (result.value.role == 'VENDOR') {
          context.go('/vendor/dashboard');
        } else {
          context.go('/home');
        }
      case Error<UserModel>():
        context.go('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserStatus(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Text(
              "Marketplace",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
