import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  CategoryButton({required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[800],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}