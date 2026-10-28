import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/category_provider.dart';
import '../../models/category_model.dart';

class CategoryEditDialog extends StatefulWidget {
  final bool isSubcategory;
  final CategoryModel? category;
  final SubcategoryModel? subcategory;

  const CategoryEditDialog({
    super.key,
    required this.isSubcategory,
    this.category,
    this.subcategory,
  });

  static Future<void> show({
    required BuildContext context,
    required bool isSubcategory,
    CategoryModel? category,
    SubcategoryModel? subcategory,
  }) async {
    return showDialog(
      context: context,
      builder: (_) => CategoryEditDialog(
        isSubcategory: isSubcategory,
        category: category,
        subcategory: subcategory,
      ),
    );
  }

  @override
  State<CategoryEditDialog> createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<CategoryEditDialog> {
  bool get isSubcategory => widget.isSubcategory;
  CategoryModel? get category => widget.category;
  SubcategoryModel? get subcategory => widget.subcategory;

  final TextEditingController parentIdController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController slugController = TextEditingController();

  String id = '';

  Future<void> _editCategory(
    BuildContext context,
    CategoryProvider provider,
    bool isSubcategory,
    String id,
  ) async {
    bool result = false;
    if (isSubcategory) {
      result = await provider.updateSubcategory(
        id,
        parentIdController.text.trim(),
        titleController.text.trim(),
        slugController.text.trim(),
      );
    } else {
      result = await provider.updateCategory(
        id,
        titleController.text.trim(),
        slugController.text.trim(),
      );
    }

    if (result) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Kategori düzenlendi.')));

      Navigator.pop(context);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kategori düzenlenemedi')));
    }
  }

  void _setControllersText() {
    if (category != null) {
      setState(() {
        id = category!.id;
        titleController.text = category!.title;
        slugController.text = category!.slug;
      });
    }
    if (subcategory != null) {
      setState(() {
        id = subcategory!.id;
        parentIdController.text = subcategory!.parentId;
        titleController.text = subcategory!.title;
        slugController.text = subcategory!.slug;
      });
    }
  }

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
    _setControllersText();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
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
              onPressed: provider.isEditing
                  ? null
                  : () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: provider.isEditing
                  ? null
                  : () => _editCategory(context, provider, isSubcategory, id),
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: provider.isEditing
                  ? const CircularProgressIndicator()
                  : const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
}
