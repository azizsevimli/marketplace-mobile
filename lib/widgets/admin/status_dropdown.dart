import 'package:flutter/material.dart';

class StatusDropdown<T extends Enum> extends StatelessWidget {
  final T? selectedStatus;
  final List<DropdownMenuEntry<T>> statusList;
  final ValueChanged<T?> onSelected;
  const StatusDropdown({
    super.key,
    required this.selectedStatus,
    required this.statusList,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Durum',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        DropdownMenu<T>(
          initialSelection: selectedStatus,
          onSelected: onSelected,
          dropdownMenuEntries: statusList,
        ),
      ],
    );
  }
}
