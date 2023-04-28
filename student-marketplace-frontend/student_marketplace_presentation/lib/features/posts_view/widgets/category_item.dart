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
        margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: Material(
          type: MaterialType.transparency,
          elevation: isSelected ? 0 : 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 40,
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                border: isSelected
                    ? Border.all(color: Theme.of(context).splashColor)
                    : null,
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Center(
              child:
                  Text(label, style: Theme.of(context).textTheme.labelMedium),
            ),
          ),
        ),
      ),
    );
  }
}
