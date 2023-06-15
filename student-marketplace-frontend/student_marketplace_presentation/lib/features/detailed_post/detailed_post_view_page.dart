import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_view/photo_view.dart';

import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';
import 'package:student_marketplace_presentation/features/chat_rooms/chat_rooms_view_bloc.dart';
import 'package:student_marketplace_presentation/features/user_profile/user_profile_view_page.dart';

import '../../core/constants/enums.dart';
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
            return Container(
              color: Theme.of(context).colorScheme.surface,
              child: Center(
                child: isCupertino(context)
                    ? CupertinoActivityIndicator(
                        color: Theme.of(context).textTheme.labelMedium!.color,
                      )
                    : CircularProgressIndicator(
                        color: Theme.of(context).textTheme.labelMedium!.color,
                      ),
              ),
            );
          }
          return PlatformScaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: PlatformAppBar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              trailingActions: [
                if (state.post!.isOwn!)
                  PlatformIconButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(RouteNames.editPost, arguments: state.post),
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
              ],
              cupertino: (context, platform) =>
                  CupertinoNavigationBarData(previousPageTitle: 'Posts'),
              automaticallyImplyLeading: true,
            ),
            body: Material(
              child: Stack(
                children: [
                  ListView(
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        border:
                                            index == state.selectedImageIndex!
                                                ? Border.all(
                                                    color: Theme.of(context)
                                                        .splashColor)
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
                            imageProvider: MemoryImage(
                                state.post!.images[state.selectedImageIndex!]),
                          )),
                      Container(
                        height: MediaQuery.of(context).size.height - 400,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 10, top: 10),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40)),
                        ),
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
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer),
                                            ),
                                            Text(
                                              state.post!.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                          ]),
                                    ),
                                    if (!state.post!.isOwn!)
                                      LikeButton(
                                        size: 40,
                                        isLiked: state.isFavorite,
                                        onTap: (liked) async => BlocProvider.of<
                                                DetailedPostViewBloc>(context)
                                            .onFavoritePressed(
                                                context, state.post!.postId!),
                                      ),
                                  ]),
                            ),
                            Divider(
                              height: 0.1,
                              color: Theme.of(context).dividerColor,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Text(
                                        'Description',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer),
                                      ),
                                    ),
                                    Text(
                                      state.post!.description!,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(),
                                    )
                                  ]),
                            ),
                            Divider(
                              height: 0.1,
                              color: Theme.of(context).dividerColor,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Text(
                                        'About',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text('Sold by '),
                                        Text(
                                          state.post!.ownerName!,
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(
                                          width: 50,
                                        ),
                                        PlatformTextButton(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          cupertino: (context, platform) =>
                                              CupertinoTextButtonData(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5)),
                                          child: Text(
                                            'View Profile',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                          onPressed: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfileViewPage(
                                                          userId: state.post!
                                                              .ownerId!))),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Posted on  ',
                                        ),
                                        Text(
                                          state.post!.postingDate!,
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                            Divider(
                              height: 0.1,
                              color: Theme.of(context).dividerColor,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Statistics',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Views: ',
                                        ),
                                        Text(
                                          state.post!.viewsCount!.toString(),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 200,
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${state.post!.price} RON',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20),
                            ),
                            if (!state.post!.isOwn!)
                              GestureDetector(
                                  onTap: () async {
                                    final room = await BlocProvider.of<
                                            ChatRoomsViewBloc>(context)
                                        .createRoom(state.post!.ownerId!);

                                    Navigator.of(context).pushNamed(
                                        RouteNames.messages,
                                        arguments: room);
                                  },
                                  child: Container(
                                    width: ScreenUtil().setWidth(250),
                                    height: ScreenUtil().setWidth(80),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Center(
                                      child: Text('Message',
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(35),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  )),
                            if (!state.post!.isOwn!)
                              Container(
                                width: ScreenUtil().setWidth(250),
                                height: ScreenUtil().setWidth(80),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          RouteNames.createOrder,
                                          arguments: state.post);
                                    },
                                    child: Text(
                                      'Order',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(35),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          fontWeight: FontWeight.w600),
                                    ),
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
