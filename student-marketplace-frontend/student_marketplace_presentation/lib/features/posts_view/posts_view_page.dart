import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_state.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_view_bloc.dart';
import 'package:student_marketplace_presentation/features/posts_view/widgets/featured_item.dart';
import 'package:student_marketplace_presentation/features/shared/post_item.dart';

import '../../core/constants/enums.dart';
import '../../core/theme/colors.dart';
import 'widgets/category_item.dart';

class PostViewPage extends StatelessWidget {
  const PostViewPage({super.key});
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
            reverse: false,
            key: const PageStorageKey(0),
            // controller: _scrollController,
            slivers: state.status == PostsViewStatus.loaded
                ? _buildPostsLoadedWidgets(context, state)
                : [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5),
                            height: ScreenUtil().setHeight(100),
                            child: PlatformTextField(
                              hintText: _getSearchHint(state),
                              cupertino: (context, target) =>
                                  _searchCupertinoTextFieldData(context),
                            )),
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
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              height: ScreenUtil().setHeight(100),
              child: PlatformTextField(
                  hintText: _getSearchHint(state),
                  onChanged: (text) => BlocProvider.of<PostViewBloc>(context)
                      .onSearchQueryChanged(text),
                  cupertino: (context, target) =>
                      _searchCupertinoTextFieldData(context),
                  onSubmitted: (text) => BlocProvider.of<PostViewBloc>(context)
                      .fetchAllPostsByTextQuery(text))),
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
          if (state.featuredPost != null)
            SizedBox(
                height: ScreenUtil().setHeight(500),
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
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        ),
      )
    ];
  }

  String _getSearchHint(PostViewState state) {
    return state.selectedCategoryIndex != -1
        ? 'Search in ${state.categories[state.selectedCategoryIndex - 1].name}'
        : 'Search';
  }

  CupertinoTextFieldData _searchCupertinoTextFieldData(BuildContext context) {
    return CupertinoTextFieldData(
      padding: const EdgeInsets.only(left: 10),
      prefix: const SizedBox(
        width: 30,
        height: 30,
        child: Icon(
          CupertinoIcons.search,
          color: accentColor,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.black12)),
    );
  }
}
