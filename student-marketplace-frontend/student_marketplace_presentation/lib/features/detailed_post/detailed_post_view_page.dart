import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:student_marketplace_presentation/features/user_profile/user_profile_view_page.dart';

import '../../core/constants/enums.dart';
import '../../core/theme/colors.dart';
import '../favorites/favorites_view_bloc.dart';
import 'detailed_post_view_bloc.dart';
import 'detailed_post_view_state.dart';

class DetailedPostViewPage extends StatelessWidget {
  final int postId;
  final sl = GetIt.instance;
  DetailedPostViewPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DetailedPostViewBloc>()..fetchDetailedPost(postId),
      child: BlocBuilder<DetailedPostViewBloc, DetailedPostViewState>(
        builder: (context, state) {
          if (state.status == PostsViewStatus.fail) {
            return const Center(child: Text('Error while loading post ...'));
          }
          if (state.status == PostsViewStatus.loading ||
              state.status == PostsViewStatus.initial) {
            return Center(
              child: isCupertino(context)
                  ? const CupertinoActivityIndicator()
                  : const CircularProgressIndicator(),
            );
          }
          return PlatformScaffold(
            appBar: PlatformAppBar(
                trailingActions: [
                  if (state.post!.isOwn!)
                    PlatformIconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: accentColor,
                      ),
                    )
                ],
                cupertino: (context, platform) =>
                    CupertinoNavigationBarData(previousPageTitle: 'Posts'),
                automaticallyImplyLeading: true,
                backgroundColor: Colors.white),
            body: Material(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 80),
                    color: secondaryColor,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.post!.images.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () =>
                                        BlocProvider.of<DetailedPostViewBloc>(
                                                context)
                                            .setSelectedImage(index),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: index ==
                                                  state.selectedImageIndex!
                                              ? Border.all(color: accentColor)
                                              : null,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      width: 80,
                                      height: 70,
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      padding: const EdgeInsets.all(5),
                                      child: Center(
                                          child: Image.memory(
                                        state.post!.images[index],
                                        width: 40,
                                        height: 40,
                                      )),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(20),
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: PhotoView(
                              imageProvider: MemoryImage(state
                                  .post!.images[state.selectedImageIndex!]),
                            )
                            // child: Image.memory(
                            //   state.post!.images[state.selectedImageIndex!],
                            //   fit: BoxFit.scaleDown,
                            // ),
                            ),
                        Container(
                          // margin: const EdgeInsets.only(left: 20, right: 20),
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 10, top: 10),
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40)),
                          ),
                          //  BorderRadius.all(Radius.circular(20)),
                          child: Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                state.post!.categoryName!,
                                                style: const TextStyle(
                                                    color: accentColor),
                                              ),
                                              Text(
                                                state.post!.title,
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ]),
                                      ),
                                      if (!state.post!.isOwn!)
                                        LikeButton(
                                          size: 40,
                                          isLiked: state.isFavorite,
                                          onTap: (liked) async => BlocProvider
                                                  .of<DetailedPostViewBloc>(
                                                      context)
                                              .onFavoritePressed(
                                                  context, state.post!.postId!),
                                        ),
                                    ]),
                              ),
                              const Divider(
                                height: 0.1,
                                color: Colors.black26,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.feed,
                                              color: accentColor,
                                            ),
                                            Text(
                                              'Description',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        state.post!.description!,
                                        textAlign: TextAlign.start,
                                      )
                                    ]),
                              ),
                              const Divider(
                                height: 0.1,
                                color: Colors.black26,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.info_outline,
                                              color: accentColor,
                                            ),
                                            Text(
                                              'About',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Sold by ',
                                            style: TextStyle(
                                                color: Colors.black38),
                                          ),
                                          Text(
                                            state.post!.ownerName!,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Posted on  ',
                                            style: TextStyle(
                                                color: Colors.black38),
                                          ),
                                          Text(
                                            state.post!.postingDate!,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                              const Divider(
                                height: 0.1,
                                color: Colors.black26,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.insert_chart,
                                              color: accentColor,
                                            ),
                                            Text(
                                              'Statistics',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Views: ',
                                            style: TextStyle(
                                                color: Colors.black38),
                                          ),
                                          Text(
                                            state.post!.viewsCount!.toString(),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ]),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${state.post!.price} RON',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(50),
                                  fontWeight: FontWeight.w700),
                            ),
                            if (!state.post!.isOwn!)
                              GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserProfileViewPage(
                                                  userId:
                                                      state.post!.ownerId!))),
                                  child: Container(
                                    height: ScreenUtil().setWidth(80),
                                    width: ScreenUtil().setWidth(160),
                                    decoration: const BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Center(
                                      child: Text('👤Profile',
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(40),
                                              color: accentColor,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  )),
                            if (!state.post!.isOwn!)
                              Container(
                                width: ScreenUtil().setWidth(250),
                                height: ScreenUtil().setWidth(80),
                                decoration: const BoxDecoration(
                                    color: accentColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: Text(
                                    '✉️ Message',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(40),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
