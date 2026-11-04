import 'package:flutter/material.dart';

class UserExpansionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<({String rowTitle, String rowValue})> rowList;

  const UserExpansionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rowList,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      childrenPadding: const EdgeInsets.all(8.0),
      title: Text(title),
      subtitle: Text(subtitle),
      children: [
        if (rowList.isEmpty)
          const Center(child: Text('Bilgi bulunmuyor.'))
        else
          for (final row in rowList) _buildRow(row.rowTitle, row.rowValue),
      ],
    );
  }

  Row _buildRow(String rowTitle, String rowValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(rowTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(rowValue),
      ],
    );
  }
}
