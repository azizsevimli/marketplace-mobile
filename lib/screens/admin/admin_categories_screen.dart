import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/category_provider.dart';
import '../../models/category_model.dart';
import '../../widgets/admin/admin_appbars.dart';
import '../../widgets/admin/category_create_dialog.dart';
import '../../widgets/admin/category_expansion_tile.dart';
import '../../widgets/admin/error_screen.dart';
import '../../widgets/admin/loading_screen.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  TextEditingController parentIdController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController slugController = TextEditingController();

  @override
  void dispose() {
    parentIdController.dispose();
    titleController.dispose();
    slugController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminScreensAppBar(context: context, title: 'Kategoriler'),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildBody() {
    final provider = context.watch<CategoryProvider>();

    if (provider.isLoading) {
      return const LoadingScreen();
    }

    if (provider.errorMessage != null) {
      return ErrorScreen(
        errorMessage: provider.errorMessage!,
        onPressed: provider.fetchCategories,
      );
    }

    if (provider.categories.isEmpty) {
      return const Center(child: Text('Henüz kategori oluşturulmadı.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      itemCount: provider.categories.length,
      itemBuilder: (context, index) {
        final CategoryModel category = provider.categories[index];
        return CategoryExpansionTile(category: category);
      },
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () =>
          CategoryCreateDialog.show(context: context, isSubcategory: false),
      icon: const Icon(Icons.add),
      label: const Text('Yeni Kategori'),
    );
  }
}
