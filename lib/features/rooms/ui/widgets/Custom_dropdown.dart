import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final ValueNotifier<String?> selectedLevelNotifier;
  final List<String> items;
  final Function()? onTap;

  const CustomDropdown({
    required this.selectedLevelNotifier,
    required this.items, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedLevelNotifier,
      builder: (context, selectedLevel, _) {
        return DropdownButton<String>(
          value: selectedLevel,
          hint: const Text("Select Level"),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) {
            selectedLevelNotifier.value = newValue;
          },
          onTap: onTap,
        );
      },
    );
  }
}