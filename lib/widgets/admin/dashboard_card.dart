import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String titleValue;
  final List<({String subtitle, String value})> subtitles;
  final IconData icon;
  final String buttonTitle;
  final String route;

  const DashboardCard({
    super.key,
    required this.title,
    required this.titleValue,
    required this.subtitles,
    required this.icon,
    required this.buttonTitle,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              titleValue,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
          children: [
            const Divider(),
            for (final subtitle in subtitles)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subtitle.subtitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(subtitle.value),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.push(route),
                  child: Text(buttonTitle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
