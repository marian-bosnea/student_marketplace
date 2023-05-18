import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  CategoryItem(
      {super.key,
      required this.label,
      required this.onTap,
      required this.isSelected});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  final shadow = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Material(
          type: MaterialType.card,
          borderRadius: BorderRadius.circular(15),
          elevation: isSelected ? 2 : 5,
          color: isSelected
              ? Theme.of(context).splashColor
              : Theme.of(context).highlightColor,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 40,
            decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).splashColor
                    : Theme.of(context).highlightColor,
                border: isSelected
                    ? Border.all(color: Theme.of(context).splashColor)
                    : null,
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Text(label,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.labelMedium!.color,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
