import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/validations.dart';
import '../../services/admin_service.dart';

class NewAdminScreen extends StatefulWidget {
  const NewAdminScreen({super.key});

  @override
  State<NewAdminScreen> createState() => _NewAdminScreenState();
}

class _NewAdminScreenState extends State<NewAdminScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorMessage;
  bool isLoading = false;

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final result = await AdminService.register(
        firstName: nameController.text.trim(),
        lastName: surnameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      if (result['userId'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${result['message']} ${result['userId']}')),
        );
        setState(() => isLoading = false);
        context.pop();
      } else {
        setState(() {
          errorMessage = result['message'];
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Admin'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 16.0,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16.0,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    validator: (value) => Validations.validateName(value),
                    decoration: const InputDecoration(label: Text('İsim')),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: surnameController,
                    keyboardType: TextInputType.name,
                    validator: (value) => Validations.validateName(value),
                    decoration: const InputDecoration(label: Text('Soyisim')),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validations.validateEmail(value),
              decoration: const InputDecoration(label: Text('E-posta')),
            ),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(label: Text('Telefon')),
            ),
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) => Validations.validatePassword(value),
              decoration: const InputDecoration(label: Text('Şifre')),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : register,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Admin Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
