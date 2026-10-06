import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/validations.dart';
import '../../services/auth_service.dart';

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({super.key});

  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisible = false;
  bool isLoggingIn = false;

  Future<void> _login({required BuildContext context}) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoggingIn = true);

      final result = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        'VENDOR',
      );

      if (!context.mounted) return;

      if (result?['user'] != null) {
        final message = result?['message'];

        setState(() => isLoggingIn = false);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));

        context.go('/vendor/dashboard');
      } else {
        final message = result?['message'];

        setState(() => isLoggingIn = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'E-posta veya şifre hatalı!')),
        );
      }
    }
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            _buildForm(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Satıcı hesabınız yok mu?"),
                TextButton(
                  onPressed: () {
                    context.go('/vendor/register');
                  },
                  child: const Text("Kayıt Olun"),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/login');
              },
              icon: Icon(Icons.person_outline, size: 24),
              label: Text("Müşteri Girişi"),
            ),
          ],
        ),
      ),
    );
  }

  Form _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
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
    );
  }
}
