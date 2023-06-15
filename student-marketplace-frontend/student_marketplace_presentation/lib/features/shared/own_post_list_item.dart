import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

import '../../core/theme/theme_data.dart';
import '../detailed_post/detailed_post_view_page.dart';

class OwnPostListItem extends StatelessWidget {
  final SalePostEntity post;

  const OwnPostListItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5, bottom: 5),
      height: 150,
      child: OpenContainer(
        closedColor: Theme.of(context).colorScheme.secondaryContainer,
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: const Duration(milliseconds: 500),
        openShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        closedBuilder: (BuildContext context, void Function() action) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                        Text(
                          '${post.price} RON',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        Row(
                          children: [
                            Text(
                              'Posted on: ',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                            Text(
                              post.postingDate!.toString(),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ]),
                ),
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
