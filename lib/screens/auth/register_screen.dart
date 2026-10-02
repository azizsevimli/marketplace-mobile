import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/validations.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
        'CUSTOMER',
      );

      if (!context.mounted) return;

      if (result?['userId'] != null) {
        final message = result?['message'];

        setState(() => isLoading = false);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));

        context.go('/home');
      } else {
        final message = result?['message'];

        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'E-posta veya şifre hatalı!')),
        );
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
                Text("Hesabınız var mı?"),
                TextButton(
                  onPressed: () {
                    context.go('/login');
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
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _surnameController,
                  validator: Validations.validateName,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: 'Surname'),
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
              labelText: 'Password',
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
