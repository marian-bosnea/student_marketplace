import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {super.key,
      required this.label,
      required this.onTap,
      required this.isSelected});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 5, right: 5),
        height: 20,
        decoration: BoxDecoration(
            color: isSelected ? accentColor : null,
            border: !isSelected ? Border.all(color: textColor) : null,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  color: isSelected ? Colors.white : textColor,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
