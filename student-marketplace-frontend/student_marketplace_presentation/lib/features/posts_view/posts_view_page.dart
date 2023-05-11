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

    _pagingController.addPageRequestListener((pageKey) async {
      await _pageBloc.fetchPostsPage(pageKey, _pagingController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: BlocBuilder<PostViewBloc, PostViewState>(
          bloc: _pageBloc,
          builder: (context, state) {
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
          key: const PageStorageKey(1),
          pagingController: _pagingController,
          showNoMoreItemsIndicatorAsGridChild: false,
          showNewPageProgressIndicatorAsGridChild: false,
          builderDelegate: PagedChildBuilderDelegate(
            animateTransitions: true,
            transitionDuration: const Duration(milliseconds: 500),
            noItemsFoundIndicatorBuilder: (context) {
              return const Center(
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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
