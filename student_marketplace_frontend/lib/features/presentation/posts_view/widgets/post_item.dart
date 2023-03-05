import 'package:flutter/material.dart';
import 'package:student_marketplace_frontend/core/theme/colors.dart';
import 'package:student_marketplace_frontend/features/domain/entities/sale_post_entity.dart';

class PostItem extends StatelessWidget {
  final SalePostEntity post;

  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: const Icon(Icons.favorite)),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.memory(post.images.first),
          ),
          Text(
            post.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: accentTextcolor, fontSize: 14),
          ),
          Text('${post.price} RON',
              textAlign: TextAlign.center,
              style: TextStyle(color: accentTextcolor, fontSize: 18)),
        ],
      ),
    );
  }
}
