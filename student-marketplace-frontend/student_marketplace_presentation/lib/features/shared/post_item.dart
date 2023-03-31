import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';
import 'package:animations/animations.dart';

import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/features/detailed_post/detailed_post_view_page.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_view_bloc.dart';

import '../../core/theme/colors.dart';
import '../detailed_post/detailed_post_view_bloc.dart';

class PostItem extends StatelessWidget {
  final SalePostEntity post;
  late bool _isFavorite;

  PostItem({
    super.key,
    required this.post,
  }) {
    _isFavorite = post.isFavorite!;
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 500),
      openShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      closedBuilder: (BuildContext context, void Function() action) {
        return Container(
          decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: post.isOwn!
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    if (post.isOwn!)
                      PlatformText(
                        'Posted by you',
                        style: TextStyle(color: accentTextcolor),
                      ),
                    if (!post.isOwn!)
                      LikeButton(
                        isLiked: _isFavorite,
                        onTap: (isLiked) async {
                          final result =
                              await BlocProvider.of<PostViewBloc>(context)
                                  .onFavoriteButtonPressed(
                                      context, post, _isFavorite);
                          _isFavorite = result;
                          return result;
                        },
                      )
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(300),
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

  void _fetchDetailedPost(BuildContext context) async {}
}
