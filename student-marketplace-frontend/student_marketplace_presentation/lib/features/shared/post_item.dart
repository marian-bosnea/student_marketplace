import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:animations/animations.dart';

import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/features/detailed_post/detailed_post_view_page.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_view_bloc.dart';

class PostItem extends StatefulWidget {
  final SalePostEntity post;

  const PostItem({
    super.key,
    required this.post,
  });

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late bool _isFavorite;
  @override
  void initState() {
    _isFavorite = widget.post.isFavorite!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 500),
      closedElevation: 5,
      closedColor: Theme.of(context).highlightColor,
      openColor: Theme.of(context).primaryColor,
      openShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      closedBuilder: (BuildContext context, void Function() action) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
              ),
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          height: ScreenUtil().setHeight(350),
                          width: ScreenUtil().setWidth(350),
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Image.memory(
                                widget.post.images.first,
                                fit: BoxFit.cover,
                                errorBuilder: (context, erorr, stacktrace) =>
                                    Text("Error"),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(
                      widget.post.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text('${widget.post.price} RON',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).splashColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ])
                ],
              ),
            ),
            if (!widget.post.isOwn!)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Center(
                    child: LikeButton(
                      isLiked: _isFavorite,
                      onTap: (isLiked) async {
                        final result =
                            await BlocProvider.of<PostViewBloc>(context)
                                .onFavoriteButtonPressed(
                                    context, widget.post, _isFavorite);
                        _isFavorite = result;
                        return result;
                      },
                    ),
                  ),
                ),
              )
          ],
        );
      },
      openBuilder:
          (BuildContext context, void Function({Object? returnValue}) action) {
        return DetailedPostViewPage(
          postId: widget.post.postId!,
        );
      },
    );
  }
}
