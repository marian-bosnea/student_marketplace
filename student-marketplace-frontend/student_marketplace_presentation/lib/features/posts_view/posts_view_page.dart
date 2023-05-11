import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

import 'package:student_marketplace_presentation/features/posts_view/posts_state.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_view_bloc.dart';
import 'package:student_marketplace_presentation/features/posts_view/widgets/featured_item.dart';
import 'package:student_marketplace_presentation/features/shared/post_item.dart';

import '../../core/config/injection_container.dart';
import '../../core/constants/enums.dart';
import 'widgets/category_item.dart';

class PostViewPage extends StatefulWidget {
  const PostViewPage({super.key});

  @override
  State<PostViewPage> createState() => _PostViewPageState();
}

class _PostViewPageState extends State<PostViewPage>
    with AutomaticKeepAliveClientMixin<PostViewPage> {
  late PagingController<int, SalePostEntity> _pagingController;
  late PostViewBloc _pageBloc;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 0);
    _pageBloc = sl<PostViewBloc>();

    _pageBloc.fetchPostsPage(0, _pagingController);

    _pagingController.addPageRequestListener((pageKey) {
      _pageBloc.fetchPostsPage(pageKey, _pagingController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child:
          BlocConsumer<PostViewBloc, PostViewState>(listener: (context, state) {
        if (state.status == PostsViewStatus.initial) {
          _pageBloc.fetchPostsPage(0, _pagingController);
        }

        _pagingController.addPageRequestListener((pageKey) {
          _pageBloc.fetchPostsPage(pageKey, _pagingController);
        });

        _pagingController.addStatusListener((status) {});
      }, builder: (context, state) {
        return RefreshIndicator(
          color: Theme.of(context).splashColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async => _pagingController.refresh(),
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
    return _buildPostsLoadedWidgets(context, state);

    // switch (state.status) {
    //   case PostsViewStatus.initial:
    //     return [const SliverToBoxAdapter()];
    //   case PostsViewStatus.loading:
    //     return [
    //       SliverToBoxAdapter(
    //         child: _buildShimmerWidget(context),
    //       )
    //     ];
    //   case PostsViewStatus.loaded:
    //     if (state.posts.isEmpty) {
    //       return [
    //         const SliverToBoxAdapter(
    //             child: EmptyListPlaceholder(
    //                 message: 'There is no item in this category'))
    //       ];
    //     }
    //     return _buildPostsLoadedWidgets(context, state);
    //   case PostsViewStatus.fail:
    //     return [
    //       const SliverToBoxAdapter(
    //         child: Center(child: Text('Failed to load posts')),
    //       )
    //     ];
    // }
  }

  SizedBox _buildShimmerWidget(BuildContext context) {
    return SizedBox(
        height: ScreenUtil().setHeight(1500),
        child: Shimmer.fromColors(
            baseColor: Theme.of(context).highlightColor,
            highlightColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                children: shimmerChildren(context),
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
        sliver: PagedSliverGrid<int, SalePostEntity>(
          key: const PageStorageKey(0),
          pagingController: _pagingController,
          showNoMoreItemsIndicatorAsGridChild: false,
          showNewPageProgressIndicatorAsGridChild: false,
          builderDelegate: PagedChildBuilderDelegate(
            animateTransitions: true,
            transitionDuration: const Duration(milliseconds: 500),
            noItemsFoundIndicatorBuilder: (context) {
              return Center(
                child: Text('No items found'),
              );
            },
            noMoreItemsIndicatorBuilder: (context) {
              return const Center(child: Text('No more posts'));
            },
            newPageProgressIndicatorBuilder: (context) {
              return isMaterial(context)
                  ? const CircularProgressIndicator()
                  : const CupertinoActivityIndicator();
            },
            itemBuilder: (context, post, index) {
              return PostItem(
                post: post,
              );
            },
          ),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        ),
      )
    ];
  }

  shimmerChildren(BuildContext context) => [
        Container(
          width: ScreenUtil().setWidth(200),
          decoration: BoxDecoration(
              color: Theme.of(context).splashColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ),
        Container(
          width: ScreenUtil().setWidth(200),
          decoration: BoxDecoration(
              color: Theme.of(context).splashColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ),
        Container(
          width: ScreenUtil().setWidth(200),
          decoration: BoxDecoration(
              color: Theme.of(context).splashColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ),
        Container(
          width: ScreenUtil().setWidth(200),
          decoration: BoxDecoration(
              color: Theme.of(context).splashColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ),
        Container(
          width: ScreenUtil().setWidth(200),
          decoration: BoxDecoration(
              color: Theme.of(context).splashColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ),
      ];

  @pragma('UI callback handlers')
  _onRefresh(BuildContext context, PostViewState state) {
    if (state.selectedCategoryIndex == -1) {
      //  BlocProvider.of<PostViewBloc>(context).fetchPostsPage(0);
    } else {
      BlocProvider.of<PostViewBloc>(context).fetchAllPostsOfSelectedCategory();
    }
  }

  @override
  void dispose() {
    //_pagingController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;
}
