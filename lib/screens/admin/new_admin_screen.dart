import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/providers/admin_users_provider.dart';
import '../../core/utils/validations.dart';
import '../../widgets/admin/admin_appbars.dart';

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

  Future<void> handleRegister(AdminUsersProvider provider) async {
    final data = createData();

    if (data != null) {
      await provider.registerAdmin(data);

      if (!mounted) return;

      if (provider.newAdminId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${provider.newAdminId} id numarası ile admin oluşturuldu.',
            ),
          ),
        );
        context.pop();
      } else {
        if (provider.errorMessage != null) {
          debugPrint(provider.errorMessage);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
        }
      }
    }
  }

  Map<String, dynamic>? createData() {
    if (_formKey.currentState!.validate()) {
      return {
        'firstName': nameController.text.trim(),
        'lastName': surnameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text.trim(),
      };
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminScreensAppBar(context: context, title: 'Yeni Admin'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: SingleChildScrollView(
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
                decoration: const InputDecoration(
                  label: Text('Şifre'),
                  errorMaxLines: 2,
                ),
              ),
              Consumer<AdminUsersProvider>(
                builder: (context, provider, child) => ElevatedButton(
                  onPressed: provider.isRegistration
                      ? null
                      : () => handleRegister(provider),
                  child: provider.isRegistration
                      ? const CircularProgressIndicator()
                      : const Text('Admin Ekle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
