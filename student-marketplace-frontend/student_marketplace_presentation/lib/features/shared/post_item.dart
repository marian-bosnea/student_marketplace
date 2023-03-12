import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

import '../../core/theme/colors.dart';

class PostItem extends StatelessWidget {
  final SalePostEntity post;
  final VoidCallback onTap;

  const PostItem({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [LikeButton()],
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.memory(post.images.first)),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                post.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              Text('${post.price} RON',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: accentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ])
          ],
        ),
      ),
    );
  }
}
