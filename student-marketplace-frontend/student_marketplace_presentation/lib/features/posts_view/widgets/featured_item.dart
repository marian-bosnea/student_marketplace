import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

import '../../../core/theme/colors.dart';

class FeaturedItem extends StatelessWidget {
  final SalePostEntity post;
  final VoidCallback onTap;
  const FeaturedItem({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Most viewed',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: accentColor),
              ),
              Text(
                post.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              Text(
                '${post.price} RON',
                style: const TextStyle(fontSize: 20),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                width: 80,
                height: 40,
                child: PlatformElevatedButton(
                  color: accentColor,
                  padding: const EdgeInsets.all(5),
                  onPressed: onTap,
                  child: const Text(
                    'View',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ]),
          ),
          SizedBox(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Image.memory(post.images.first))),
          )
        ],
      ),
    );
  }
}
