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
      padding: const EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
      child: Material(
        elevation: 5,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          // margin: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Most viewed',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(60),
                          fontWeight: FontWeight.w500,
                          color: accentColor),
                    ),
                    Text(
                      post.title,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(60),
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${post.price} RON',
                      style: TextStyle(fontSize: ScreenUtil().setSp(50)),
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
                            width: ScreenUtil().setWidth(200),
                            height: ScreenUtil().setHeight(80),
                            decoration: const BoxDecoration(color: accentColor),
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
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Image.memory(post.images.first))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
