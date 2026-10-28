import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/category_provider.dart';
import '../../models/category_model.dart';
import 'category_create_dialog.dart';
import 'category_edit_dialog.dart';
import 'delete_dialog.dart';

class CategoryExpansionTile extends StatelessWidget {
  final CategoryModel category;
  const CategoryExpansionTile({super.key, required this.category});

  Future<void> _showDeleteDialog(
    BuildContext context,
    Future<bool> Function() onDelete,
    String title,
    String content,
  ) async {
    final isConfirmed = await DeleteDialog.show(
      context: context,
      title: title,
      content: content,
    );

    if (isConfirmed != true) return;

    final result = await onDelete();

    if (result != true) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silme işlemi gerçekleşmedi.')),
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Silindi')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      title: Text('${category.title} (${category.slug})'),
      subtitle: Text(
        category.subcategories.isNotEmpty
            ? '${category.subcategories.length} adet alt kategori bulunuyor'
            : 'Alt katagori bulunmuyor.',
      ),
      children: [
        for (final subcategory in category.subcategories)
          _buildSubcategoryRow(context, subcategory),
        _buildButtonRow(context, category),
      ],
    );
  }

  Row _buildSubcategoryRow(BuildContext context, SubcategoryModel subcategory) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(subcategory.title),
        Row(
          children: [
            IconButton(
              onPressed: () => CategoryEditDialog.show(
                context: context,
                isSubcategory: true,
                subcategory: subcategory,
              ),
              icon: const Icon(Icons.edit),
              color: Colors.blueAccent,
            ),
            IconButton(
              onPressed: () => _showDeleteDialog(
                context,
                () => context.read<CategoryProvider>().deleteSubcategory(
                  subcategory.id,
                ),
                subcategory.title,
                'Alt kategoriyi silmek istediğinize emin misiniz?',
              ),
              icon: const Icon(Icons.delete_outlined),
              color: Colors.redAccent,
            ),
          ],
        ),
      ],
    );
  }

  Row _buildButtonRow(BuildContext context, CategoryModel category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => CategoryCreateDialog.show(
            context: context,
            isSubcategory: true,
            parnetId: category.id,
          ),
          child: const Text(
            'Alt Kategori Ekle',
            style: TextStyle(color: Colors.green),
          ),
        ),
        TextButton(
          onPressed: () => CategoryEditDialog.show(
            context: context,
            isSubcategory: false,
            category: category,
          ),
          child: const Text(
            'Düzenle',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
        TextButton(
          onPressed: () => _showDeleteDialog(
            context,
            () => context.read<CategoryProvider>().deleteCategory(category.id),
            category.title,
            'Kategoriyi silmek istediğinize emin misiniz?',
          ),
          child: const Text('Sil', style: TextStyle(color: Colors.redAccent)),
        ),
      ],
    );
  }
}
