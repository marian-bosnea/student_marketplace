import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

import '../../core/theme/colors.dart';
import '../detailed_post/detailed_post_view_page.dart';

class FavoriteListItem extends StatelessWidget {
  final SalePostEntity post;

  const FavoriteListItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: ScreenUtil().setHeight(400),
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
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(50),
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          height: ScreenUtil().setHeight(80),
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text(
                            post.categoryName!,
                            style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                          ),
                        ),
                        Text(
                          '${post.price} RON',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(50),
                              color: accentColor),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              "Posted by ${post.ownerName}",
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: ScreenUtil().setSp(40),
                              ),
                            )),
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
