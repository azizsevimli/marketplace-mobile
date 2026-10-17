import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/category_provider.dart';
import '../../models/category_model.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  TextEditingController parentIdController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController slugController = TextEditingController();

  Future<void> _showCreateDialog({
    required BuildContext context,
    String? title,
    Future<void> Function(String title, String slug)? createFunction,
    Future<void> Function(String parentId, String title, String slug)?
    createSubFunction,
    required bool isSub,
    String? parentId,
  }) async {
    parentIdController.text = parentId ?? '';
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dContext) => Consumer<CategoryProvider>(
        builder: (bContext, provider, child) {
          return AlertDialog(
            title: Text(title ?? 'Yeni Kategori'),
            content: SingleChildScrollView(
              child: ListBody(children: _buildTextFields(isSub)),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: provider.isCreating
                    ? null
                    : () {
                        Navigator.of(dContext).pop();
                      },
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: provider.isCreating
                    ? null
                    : () async {
                        if (createFunction != null) {
                          await createFunction(
                            titleController.text.trim(),
                            slugController.text.trim(),
                          );
                        } else if (createSubFunction != null) {
                          await createSubFunction(
                            parentIdController.text.trim(),
                            titleController.text.trim(),
                            slugController.text.trim(),
                          );
                        }

                        titleController.text = '';
                        slugController.text = '';

                        if (dContext.mounted && !provider.isCreating) {
                          Navigator.of(dContext).pop();
                        }
                      },
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
      ),
    );
  }

  Future<void> _showEditDialog({
    required BuildContext context,
    CategoryModel? category,
    SubcategoryModel? subcategory,
    Future<bool> Function(String id, String title, String slug)? editFunction,
    Future<bool> Function(
      String id,
      String parentId,
      String title,
      String slug,
    )?
    editSubFunction,
    required bool isSub,
  }) async {
    if (isSub && subcategory != null) {
      parentIdController.text = subcategory.parentId;
      titleController.text = subcategory.title;
      slugController.text = subcategory.slug;
    } else if (!isSub && category != null) {
      titleController.text = category.title;
      slugController.text = category.slug;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dContext) => Consumer<CategoryProvider>(
        builder: (bContext, provider, child) {
          return AlertDialog(
            title: Text(category?.title ?? subcategory?.title ?? ''),
            content: SingleChildScrollView(
              child: ListBody(children: _buildTextFields(isSub)),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: provider.isEditing
                    ? null
                    : () {
                        Navigator.of(dContext).pop();
                      },
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: provider.isEditing
                    ? null
                    : () async {
                        bool result = false;
                        if (editFunction != null) {
                          result = await editFunction(
                            category!.id,
                            titleController.text.trim(),
                            slugController.text.trim(),
                          );
                        } else if (editSubFunction != null) {
                          result = await editSubFunction(
                            subcategory!.id,
                            parentIdController.text.trim(),
                            titleController.text.trim(),
                            slugController.text.trim(),
                          );
                        }

                        titleController.text = '';
                        slugController.text = '';

                        debugPrint(result.toString());

                        if (dContext.mounted && !provider.isEditing) {
                          if (result) {
                            Navigator.of(dContext).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Kategori düzenlenemedi')),
                            );
                          }
                        }
                      },
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
      ),
    );
  }

  Future<void> _showDeleteDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String id,
    required Future<void> Function(String id) deleteFunction,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dContext) => Consumer<CategoryProvider>(
        builder: (bContext, provider, child) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: provider.isDeleting
                    ? null
                    : () {
                        Navigator.of(dContext).pop();
                      },
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: provider.isDeleting
                    ? null
                    : () async {
                        await deleteFunction(id);

                        if (dContext.mounted && !provider.isDeleting) {
                          Navigator.of(dContext).pop();
                        }
                      },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                child: provider.isDeleting
                    ? const CircularProgressIndicator()
                    : const Text('Sil'),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildTextFields(bool isSub) {
    return <Widget>[
      if (isSub) ...[
        TextField(
          controller: parentIdController,
          enabled: false,
          decoration: InputDecoration(label: Text('Ana Kategori')),
        ),
      ],
      TextField(
        controller: titleController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(label: Text('İsim')),
      ),
      SizedBox(height: 8.0),
      TextField(
        controller: slugController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(label: Text('Slug')),
      ),
    ];
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kategoriler')),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildBody() {
    final provider = context.watch<CategoryProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hata: ${provider.errorMessage}'),
            ElevatedButton(
              onPressed: provider.fetchCategories,
              child: const Text('Yeniden Dene'),
            ),
          ],
        ),
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
        return ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 8.0),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          title: Text('${category.title} (${category.slug})'),
          subtitle: Text(
            category.subcategories.isNotEmpty
                ? '${category.subcategories.length} adet alt kategori bulunuyor'
                : 'Alt katagori bulunmuyor.',
          ),
          children: [
            for (SubcategoryModel subcategory in category.subcategories) ...[
              _buildSubcategoryRow(context, provider, subcategory),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _showCreateDialog(
                    context: context,
                    title: category.title,
                    createSubFunction: provider.createSubcategory,
                    isSub: true,
                    parentId: category.id,
                  ),
                  child: const Text(
                    'Alt Kategori Ekle',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                TextButton(
                  onPressed: () => _showEditDialog(
                    context: context,
                    category: category,
                    editFunction: provider.updateCategory,
                    isSub: false,
                  ),
                  child: const Text(
                    'Düzenle',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                TextButton(
                  onPressed: () => _showDeleteDialog(
                    context: context,
                    title: category.title,
                    content: 'Kategoriyi silmek istediğinize emin misiniz?',
                    id: category.id,
                    deleteFunction: provider.deleteCategory,
                  ),
                  child: const Text(
                    'Sil',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubcategoryRow(
    BuildContext context,
    CategoryProvider provider,
    SubcategoryModel subcategory,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(subcategory.title),
        Row(
          children: [
            IconButton(
              onPressed: () => _showEditDialog(
                context: context,
                subcategory: subcategory,
                editSubFunction: provider.updateSubcategory,
                isSub: true,
              ),
              icon: const Icon(Icons.edit),
              color: Colors.blueAccent,
            ),
            IconButton(
              onPressed: () => _showDeleteDialog(
                context: context,
                title: subcategory.title,
                content: 'Alt kategoriyi silmek istediğinize emin misiniz?',
                id: subcategory.id,
                deleteFunction: provider.deleteSubcategory,
              ),
              icon: const Icon(Icons.delete_outlined),
              color: Colors.redAccent,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showCreateDialog(
        context: context,
        createFunction: context.read<CategoryProvider>().createCategory,
        isSub: false,
      ),
      icon: const Icon(Icons.add),
      label: const Text('Yeni Kategori'),
    );
  }
}
