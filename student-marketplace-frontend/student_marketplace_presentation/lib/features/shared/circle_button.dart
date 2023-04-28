import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onTap;

  const CircleButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
              color: Theme.of(context).splashColor,
              borderRadius: const BorderRadius.all(Radius.circular(50))),
          child: icon,
        ),
      ),
    );
  }
}
