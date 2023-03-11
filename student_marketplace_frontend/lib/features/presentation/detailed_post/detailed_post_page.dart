import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_frontend/core/enums.dart';
import 'package:student_marketplace_frontend/core/theme/colors.dart';
import 'package:student_marketplace_frontend/features/presentation/detailed_post/detailed_post_cubit.dart';
import 'package:student_marketplace_frontend/features/presentation/detailed_post/detailed_post_state.dart';

class DetailedPostPage extends StatelessWidget {
  final String postId;
  const DetailedPostPage({super.key, required this.postId});

  _init(BuildContext context) async {
    BlocProvider.of<DetailedPostCubit>(context).fetchDetailedPost(postId);
    BlocProvider.of<DetailedPostCubit>(context).checkIfFavorite(postId);
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    return BlocBuilder<DetailedPostCubit, DetailedPostPageState>(
      builder: (context, state) {
        if (state.status == PostsViewStatus.fail) {
          return const Center(child: Text('Error while loading post ...'));
        }
        if (state.status == PostsViewStatus.loading) {
          return Center(
            child: isCupertino(context)
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(),
          );
        }
        return PlatformScaffold(
          appBar: PlatformAppBar(
              cupertino: (context, platform) =>
                  CupertinoNavigationBarData(previousPageTitle: 'Posts'),
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white),
          body: Material(
            child: Container(
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
                                  BlocProvider.of<DetailedPostCubit>(context)
                                      .setSelectedImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: index == state.selectedImageIndex!
                                        ? Border.all(color: accentColor)
                                        : null,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                width: 80,
                                height: 70,
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
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
                    child: Image.memory(
                      state.post!.images[state.selectedImageIndex!],
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 10, top: 10),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${state.post!.price} RON',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ]),
                                ),
                                PlatformIconButton(
                                  onPressed: () => BlocProvider.of<
                                          DetailedPostCubit>(context)
                                      .onFavoritePressed(state.post!.postId!),
                                  padding: const EdgeInsets.all(5),
                                  icon: Icon(
                                    state.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ]),
                        ),
                        const Divider(
                          height: 0.1,
                          color: Colors.black26,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 5),
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
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 5),
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
                                      style: TextStyle(color: Colors.black38),
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
                                      style: TextStyle(color: Colors.black38),
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
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 5),
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
                                      style: TextStyle(color: Colors.black38),
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
          ),
        );
      },
    );
  }
}
