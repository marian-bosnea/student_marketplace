import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

import '../../core/theme/theme_data.dart';
import '../detailed_post/detailed_post_view_page.dart';

class FavoriteListItem extends StatelessWidget {
  final SalePostEntity post;

  const FavoriteListItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: Theme.of(context).colorScheme.surfaceVariant,
      openColor: Theme.of(context).highlightColor,
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 500),
      openShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      closedBuilder: (BuildContext context, void Function() action) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: SizedBox(
                    width: 170,
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Image.memory(post.images.first))),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          height: ScreenUtil().setHeight(70),
                          width: ScreenUtil().setWidth(300),
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            post.categoryName!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer),
                          ),
                        ),
                        Text(
                          '${post.price} RON',
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        );
      },
      openBuilder:
          (BuildContext context, void Function({Object? returnValue}) action) {
        return DetailedPostViewPage(
          postId: post.postId!,
        );
      },
    );
  }
}
