import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  const DeleteDialog({super.key, required this.title, required this.content});

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => DeleteDialog(title: title, content: content),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          child: const Text('Sil'),
        ),
      ],
    );
  }
}
