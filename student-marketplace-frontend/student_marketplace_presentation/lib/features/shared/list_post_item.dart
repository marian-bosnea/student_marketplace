import 'package:flutter/material.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

import '../../core/theme/colors.dart';

class ListPostItem extends StatelessWidget {
  final SalePostEntity post;
  final VoidCallback onTap;

  const ListPostItem({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 2,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Image.memory(post.images.first))),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${post.price} RON',
                        style:
                            const TextStyle(fontSize: 16, color: accentColor),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
