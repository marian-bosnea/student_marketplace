import 'package:flutter/material.dart';
import 'package:student_marketplace_frontend/features/domain/entities/sale_post_entity.dart';

import '../../../../core/theme/colors.dart';

class ListPostItem extends StatelessWidget {
  final SalePostEntity post;
  final VoidCallback onTap;

  const ListPostItem({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Image.memory(post.images.first))),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${post.price} RON',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
