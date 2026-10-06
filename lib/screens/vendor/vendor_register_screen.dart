import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/validations.dart';
import '../../services/auth_service.dart';

class VendorRegisterScreen extends StatefulWidget {
  const VendorRegisterScreen({super.key});

  @override
  State<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends State<VendorRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  bool isVisible = false;

  Future<void> _register({required BuildContext context}) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final result = await AuthService.register(
        _nameController.text.trim(),
        _surnameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        'VENDOR',
      );

      if (!context.mounted) return;

      if (result?['userId'] != null) {
        final message = result?['message'];

        setState(() => isLoading = false);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));

        context.go('/vendor/dashboard');
      } else {
        final message = result?['message'];

        setState(() => isLoading = false);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            _buildForm(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Satıcı hesabınız var mı?"),
                TextButton(
                  onPressed: () {
                    context.go('/vendor/login');
                  },
                  child: Text("Giriş Yap"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          Row(
            spacing: 20,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  validator: Validations.validateName,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: 'Ad'),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _surnameController,
                  validator: Validations.validateName,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: 'Soyad'),
                ),
              ),
            ],
          ),
          TextFormField(
            controller: _emailController,
            validator: Validations.validateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'E-posta'),
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: !isVisible,
            validator: Validations.validatePassword,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Şifre',
              suffixIcon: IconButton(
                onPressed: () => setState(() => isVisible = !isVisible),
                icon: isVisible
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _register(context: context),
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text('Kayıt Ol'),
          ),
        ],
      ),
    );
  }
}
