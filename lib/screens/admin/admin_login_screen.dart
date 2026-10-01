import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/validations.dart';
import '../../features/auth_service.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  bool isVisible = false;
  bool isLoggingIn = false;

  void _login({required BuildContext context}) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoggingIn = true);

      final user = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        'ADMIN',
      );

      if (!context.mounted) return;

      if (user != null) {
        setState(() => isLoggingIn = false);
        context.go('/admin/dashboard');
      } else {
        setState(() => isLoggingIn = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-posta veya şifre hatalı!')),
        );
      }
    }
  }

  Future<void> _checkUser({required BuildContext context}) async {
    setState(() => isLoading = true);
    final user = await AuthService.checkUser('ADMIN');

    if (!context.mounted) return;

    if (user != null) {
      setState(() => isLoading = false);
      context.go('/admin/dashboard');
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _checkUser(context: context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(context),
    );
  }

  Form _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            TextFormField(
              controller: _emailController,
              validator: (value) => Validations.validateEmail(value),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-posta',
                prefixIcon: Icon(Icons.mail_outline),
              ),
            ),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.trim().length < 8) {
                  return 'Geçerli bir şifre giriniz (en az 8 karakter)';
                }
                return null;
              },
              keyboardType: TextInputType.visiblePassword,
              obscureText: !isVisible,
              decoration: InputDecoration(
                labelText: 'Şifre',
                prefixIcon: const Icon(Icons.password),
                suffixIcon: IconButton(
                  onPressed: () => setState(() {
                    isVisible = !isVisible;
                  }),
                  icon: isVisible
                      ? const Icon(Icons.visibility_off_rounded)
                      : const Icon(Icons.visibility_rounded),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _login(context: context),
              child: isLoggingIn
                  ? const CircularProgressIndicator()
                  : const Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
