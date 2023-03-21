import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

import '../../core/theme/colors.dart';
import '../detailed_post/detailed_post_view_page.dart';

class OwnPostListItem extends StatelessWidget {
  final SalePostEntity post;

  const OwnPostListItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 150,
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: const Duration(milliseconds: 500),
        openShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        closedBuilder: (BuildContext context, void Function() action) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: Image.memory(post.images.first))),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          height: 30,
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text(
                            post.categoryName!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          '${post.price} RON',
                          style:
                              const TextStyle(fontSize: 20, color: accentColor),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Posted on: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              post.postingDate!.toString(),
                              style: const TextStyle(color: Colors.black45),
                            ),
                          ],
                        )
                      ]),
                ),
                SizedBox(
                  //width: 30,
                  child: Center(
                    child: Row(
                      children: [
                        const Text(
                          'Views: ',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          post.viewsCount!.toString(),
                          style: const TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        openBuilder: (BuildContext context,
            void Function({Object? returnValue}) action) {
          return DetailedPostViewPage(
            postId: post.postId!,
          );
        },
      ),
    );
  }
}
