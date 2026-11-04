import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/result.dart';
import '../../core/utils/validations.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String selectedRole = 'CUSTOMER';
  bool isVisible = false;
  bool isLoggingIn = false;

  Future<void> _login({required BuildContext context}) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoggingIn = true);

      final Result<UserModel> result = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        selectedRole,
      );

      if (!context.mounted) return;

      switch (result) {
        case Ok<UserModel>():
          setState(() => isLoggingIn = false);
          if (result.value.role == 'ADMIN') {
            context.go('/admin/dashboard');
          } else if (result.value.role == 'VENDOR') {
            context.go('/vendor/dashboard');
          } else {
            context.go('/home');
          }
        case Error<UserModel>():
          setState(() => isLoggingIn = false);

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(result.error.toString())));
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
                const Text("Hesabınız yok mu?"),
                TextButton(
                  onPressed: () {
                    context.go('/register');
                  },
                  child: const Text("Kayıt Olun"),
                ),
              ],
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
          DropdownMenu<String>(
            initialSelection: selectedRole,
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 'CUSTOMER', label: 'Customer'),
              DropdownMenuEntry(value: 'VENDOR', label: 'Vendor'),
              DropdownMenuEntry(value: 'ADMIN', label: 'Admin'),
            ],
            onSelected: (value) => setState(() => selectedRole = value!),
          ),
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
