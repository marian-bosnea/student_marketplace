import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import 'package:student_marketplace_presentation/features/posts_view/posts_state.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_view_bloc.dart';
import 'package:student_marketplace_presentation/features/posts_view/widgets/featured_item.dart';
import 'package:student_marketplace_presentation/features/shared/empty_list_placeholder.dart';
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
          onRefresh: () async => _onRefresh(context, state),
          child: CustomScrollView(
              reverse: false,
              key: const PageStorageKey(0),
              slivers: [_buildCategoryList(context, state)] +
                  _getSlivers(context, state)),
        );
      }),
    );
  }

  @pragma('Components')
  List<Widget> _getSlivers(BuildContext context, PostViewState state) {
    switch (state.status) {
      case PostsViewStatus.initial:
        return [Container()];
      case PostsViewStatus.loading:
        return [
          SliverToBoxAdapter(
            child: _buildShimmerWidget(),
          )
        ];
      case PostsViewStatus.loaded:
        if (state.posts.isEmpty) {
          return [
            const SliverToBoxAdapter(
                child: EmptyListPlaceholder(
                    message: 'There is no item in this category'))
          ];
        }
        return _buildPostsLoadedWidgets(context, state);
      case PostsViewStatus.fail:
        return [
          const SliverToBoxAdapter(
            child: Center(child: Text('Failed to load posts')),
          )
        ];
    }
  }

  SizedBox _buildShimmerWidget() {
    return SizedBox(
        height: ScreenUtil().setHeight(1500),
        child: Shimmer.fromColors(
            baseColor: secondaryColor,
            highlightColor: primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                children: [
                  Container(
                    width: ScreenUtil().setWidth(200),
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(200),
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(200),
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(200),
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  )
                ],
              ),
            )));
  }

  Widget _buildCategoryList(BuildContext context, PostViewState state) {
    return SliverToBoxAdapter(
      child: Container(
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
    );
  }

  List<Widget> _buildPostsLoadedWidgets(
      BuildContext context, PostViewState state) {
    return [
      if (state.featuredPost != null)
        SliverToBoxAdapter(
          child: SizedBox(
              height: ScreenUtil().setHeight(400),
              child: FeaturedItem(post: state.featuredPost!)),
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
              childAspectRatio: 2 / 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        ),
      )
    ];
  }

  @pragma('UI callback handlers')
  _onRefresh(BuildContext context, PostViewState state) {
    if (state.selectedCategoryIndex == -1) {
      BlocProvider.of<PostViewBloc>(context).fetchAllPosts();
    } else {
      BlocProvider.of<PostViewBloc>(context).fetchAllPostsOfSelectedCategory();
    }
  }
}
