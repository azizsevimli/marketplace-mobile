import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/category_provider.dart';

class CategoryCreateDialog extends StatelessWidget {
  final bool isSubcategory;
  final String? parentId;
  CategoryCreateDialog({super.key, required this.isSubcategory, this.parentId});

  final TextEditingController parentIdController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController slugController = TextEditingController();

  static Future<void> show({
    required BuildContext context,
    required bool isSubcategory,
    String? parnetId,
  }) async {
    return showDialog(
      context: context,
      builder: (_) => CategoryCreateDialog(
        isSubcategory: isSubcategory,
        parentId: parnetId,
      ),
    );
  }

  Future<void> _createCategory(
    BuildContext context,
    CategoryProvider provider,
    bool isSubcategory,
  ) async {
    bool result = false;
    if (isSubcategory) {
      result = await provider.createSubcategory(
        parentIdController.text.trim(),
        titleController.text.trim(),
        slugController.text.trim(),
      );
    } else {
      result = await provider.createCategory(
        titleController.text.trim(),
        slugController.text.trim(),
      );
    }

    if (result) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Kategori oluşturuldu.')));

      Navigator.pop(context);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kategori oluşturulamadı')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        parentIdController.text = parentId ?? '';
        return AlertDialog(
          title: const Text('Title'),
          content: Form(
            child: SingleChildScrollView(
              child: ListBody(
                children: [
                  if (isSubcategory)
                    TextField(
                      controller: parentIdController,
                      enabled: false,
                      decoration: const InputDecoration(
                        label: Text('Ana Kategori'),
                      ),
                    ),
                  TextField(
                    controller: titleController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(label: Text('İsim')),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: slugController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(label: Text('Slug')),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: provider.isCreating
                  ? null
                  : () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: provider.isCreating
                  ? null
                  : () => _createCategory(context, provider, isSubcategory),
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.green),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: provider.isCreating
                  ? const CircularProgressIndicator()
                  : const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
}
