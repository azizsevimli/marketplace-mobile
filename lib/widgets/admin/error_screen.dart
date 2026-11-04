import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onPressed;
  const ErrorScreen({
    super.key,
    required this.errorMessage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hata: $errorMessage', textAlign: TextAlign.justify),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('Yeniden Dene'),
            ),
          ],
        ),
      ),
    );
  }
}
