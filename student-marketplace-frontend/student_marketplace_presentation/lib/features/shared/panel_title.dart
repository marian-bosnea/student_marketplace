import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PanelTitle extends StatelessWidget {
  final String title;
  const PanelTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}
