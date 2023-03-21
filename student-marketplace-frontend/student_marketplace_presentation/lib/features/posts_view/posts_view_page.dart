import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_state.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_view_bloc.dart';
import 'package:student_marketplace_presentation/features/posts_view/widgets/featured_item.dart';
import 'package:student_marketplace_presentation/features/shared/post_item.dart';

import '../../core/constants/enums.dart';
import '../../core/theme/colors.dart';
import 'widgets/category_item.dart';

class PostViewPage extends StatelessWidget {
  PostViewPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: primaryColor,
      child:
          BlocBuilder<PostViewBloc, PostViewState>(builder: (context, state) {
        return RefreshIndicator(
          color: accentColor,
          backgroundColor: primaryColor,
          onRefresh: () async {
            if (state.selectedCategoryIndex == -1) {
              BlocProvider.of<PostViewBloc>(context).fetchAllPosts();
            } else {
              BlocProvider.of<PostViewBloc>(context)
                  .fetchAllPostsOfSelectedCategory();
            }
          },
          child: CustomScrollView(
            key: const PageStorageKey(0),
            // controller: _scrollController,
            slivers: state.status == PostsViewStatus.loaded
                ? _buildPostsLoadedWidgets(context, state)
                : [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          height: 70,
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              key: const PageStorageKey(0),
                              controller: ScrollController(),
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
                                          BlocProvider.of<PostViewBloc>(context)
                                              .selectCategory(index));
                                } else {
                                  return CategoryItem(
                                      label: '🏷️All  ',
                                      onTap: () =>
                                          BlocProvider.of<PostViewBloc>(context)
                                              .selectCategory(-1),
                                      isSelected:
                                          state.selectedCategoryIndex == -1);
                                }
                              }),
                        ),
                      ]),
                    ),
                  ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildPostsLoadedWidgets(
      BuildContext context, PostViewState state) {
    return [
      SliverList(
        delegate: SliverChildListDelegate([
          Container(
            height: 70,
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                key: const PageStorageKey(0),
                controller: ScrollController(),
                scrollDirection: Axis.horizontal,
                itemCount: state.categories.length + 1,
                itemBuilder: (context, index) {
                  if (index > 0) {
                    final category = state.categories.elementAt(index - 1);

                    return CategoryItem(
                        label: category.name,
                        isSelected: index == state.selectedCategoryIndex,
                        onTap: () => BlocProvider.of<PostViewBloc>(context)
                            .selectCategory(index));
                  } else {
                    return CategoryItem(
                        label: '🏷️All  ',
                        onTap: () => BlocProvider.of<PostViewBloc>(context)
                            .selectCategory(-1),
                        isSelected: state.selectedCategoryIndex == -1);
                  }
                }),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: FeaturedItem(post: state.featuredPost!)),
        ]),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        sliver: SliverGrid.builder(
          key: const PageStorageKey(1),
          itemCount: state.posts.length,
          itemBuilder: (context, index) {
            final post = state.posts.elementAt(index);
            return PostItem(
              post: post,
            );
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
        ),
      )
    ];
  }
}
