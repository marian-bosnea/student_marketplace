import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

import '../../../core/theme/colors.dart';
import '../../detailed_post/detailed_post_view_page.dart';

class FeaturedItem extends StatelessWidget {
  final SalePostEntity post;
  const FeaturedItem({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 20, left: 10, right: 10),
      child: Material(
        elevation: 1,
        type: MaterialType.transparency,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Most viewed',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(50),
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).splashColor),
                    ),
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      '${post.price} RON',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    OpenContainer(
                      transitionDuration: const Duration(milliseconds: 500),
                      openBuilder: (BuildContext context,
                          void Function({Object? returnValue}) action) {
                        return DetailedPostViewPage(postId: post.postId!);
                      },
                      closedBuilder:
                          (BuildContext context, void Function() action) {
                        return Container(
                            width: ScreenUtil().setWidth(180),
                            height: ScreenUtil().setHeight(70),
                            decoration: BoxDecoration(
                                color: Theme.of(context).splashColor),
                            child: Center(
                              child: Text(
                                'View',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(50)),
                              ),
                            ));
                      },
                    )
                  ]),
              SizedBox(
                child: SizedBox(
                    width: ScreenUtil().setWidth(300),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Image.memory(
                          post.images.first,
                          fit: BoxFit.cover,
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
