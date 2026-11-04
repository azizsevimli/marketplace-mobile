import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

AppBar adminScreensAppBar({
  required BuildContext context,
  required String title,
  double size = 20.0,
  Color color = Colors.black,
}) {
  return AppBar(
    title: Text(title),
    titleTextStyle: TextStyle(fontSize: size, color: color),
    leading: IconButton(
      onPressed: () => context.pop(),
      icon: const Icon(Icons.arrow_back_ios_new),
    ),
  );
}
