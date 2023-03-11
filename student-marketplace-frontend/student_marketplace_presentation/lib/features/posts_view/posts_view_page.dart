import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_presentation/features/posts_view/post_view_state.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_view_cubit.dart';
import 'package:student_marketplace_presentation/features/posts_view/widgets/featured_item.dart';
import 'package:student_marketplace_presentation/features/posts_view/widgets/post_item.dart';

import '../../core/constants/enums.dart';
import '../../core/theme/colors.dart';
import '../shared/animation_options.dart';
import 'widgets/category_item.dart';

class PostViewPage extends StatelessWidget {
  PostViewPage({super.key});

  final listShowItemDuration = const Duration(milliseconds: 100);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PostViewCubit>(context).fetchAllPosts();
    BlocProvider.of<PostViewCubit>(context).fetchAllCategories();
    return Material(
      color: primaryColor,
      child:
          BlocBuilder<PostViewCubit, PostViewState>(builder: (context, state) {
        if (state.status == PostsViewStatus.loaded) {
          return Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      height: 70,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length + 1,
                          itemBuilder: (context, index) {
                            if (index > 0) {
                              final category =
                                  state.categories.elementAt(index - 1);

                              return CategoryItem(
                                  label: category.name,
                                  isSelected:
                                      index == state.selectedCategoryIndex,
                                  onTap: () =>
                                      BlocProvider.of<PostViewCubit>(context)
                                          .selectCategory(index));
                            } else {
                              return CategoryItem(
                                  label: '  All  ',
                                  onTap: () =>
                                      BlocProvider.of<PostViewCubit>(context)
                                          .selectCategory(-1),
                                  isSelected:
                                      state.selectedCategoryIndex == -1);
                            }
                          }),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: FeaturedItem(
                        post: state.featuredPost!,
                        onTap: () => BlocProvider.of<PostViewCubit>(context)
                            .goToDetailedPostPage(
                                state.featuredPost!.postId!, context),
                      ),
                    ),
                  ]),
                ),
                LiveSliverGrid.options(
                  options: salePostAnimationOptions,
                  controller: _scrollController,
                  itemCount: state.posts.length,
                  itemBuilder: (context, index, anim) {
                    final post = state.posts.elementAt(index);
                    return AnimateIfVisible(
                        key: ValueKey(post.postId),
                        duration: const Duration(milliseconds: 200),
                        builder: (context, animation) => FadeTransition(
                              opacity: Tween<double>(begin: 0, end: 1)
                                  .animate(animation),
                              child: PostItem(
                                post: post,
                                onTap: () {
                                  BlocProvider.of<PostViewCubit>(context)
                                      .goToDetailedPostPage(
                                          post.postId!, context);
                                },
                              ),
                            ));
                    // return PostItem(
                    //   post: post,
                    //   onTap: () {
                    //     BlocProvider.of<PostViewCubit>(context)
                    //         .goToDetailedPostPage(post.postId!, context);
                    //   },
                    // );
                  },
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                )
              ],
            ),
          );
        } else if (state.status == PostsViewStatus.loading) {
          return isCupertino(context)
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        }
        return const Center(
          child: Text(
            "Failed to load posts...",
            style: TextStyle(color: Colors.red),
          ),
        );
      }),
    );
  }
}
