import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';

import 'package:student_marketplace_presentation/features/posts_view/posts_state.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_view_bloc.dart';
import 'package:student_marketplace_presentation/features/shared/post_item.dart';

import '../../core/config/injection_container.dart';
import '../shared/posts_grid_view.dart';
import 'widgets/category_item.dart';

class PostViewPage extends StatefulWidget {
  const PostViewPage({super.key});

  @override
  State<PostViewPage> createState() => _PostViewPageState();
}

class _PostViewPageState extends State<PostViewPage> {
  late PagingController<int, SalePostEntity> _pagingController;
  late PostViewBloc _pageBloc;

  @override
  void initState() {
    super.initState();

    _pagingController =
        PagingController(firstPageKey: 0, invisibleItemsThreshold: 1);
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
                  slivers: <Widget>[
                    const Header(),
                    CategoriesList(
                      state: state,
                      pagingController: _pagingController,
                    ),
                    PostsGridView(pagingController: _pagingController)
                  ]),
            );
          }),
    );
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

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
      padding: const EdgeInsets.all(20),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Explore \nStudent's Marketplace",
            maxLines: 2,
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.labelLarge!.color!),
          ),
          Hero(
            tag: 'search',
            child: Material(
              elevation: 5,
              type: MaterialType.card,
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 1, color: Theme.of(context).splashColor)),
                child: PlatformIconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(RouteNames.search),
                  icon: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    //size: 30,
                    color: Theme.of(context).splashColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class CategoriesList extends StatelessWidget {
  final PostViewState state;
  final PagingController<int, SalePostEntity> pagingController;

  const CategoriesList(
      {super.key, required this.state, required this.pagingController});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Hero(
      tag: 'categories',
      child: Container(
        height: 80,
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            key: const PageStorageKey(0),
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length + 1,
            itemBuilder: (context, index) {
              if (index > 0) {
                final category = state.categories.elementAt(index - 1);
                return CategoryItem(
                    label: category.name,
                    isSelected: index == state.selectedCategoryIndex,
                    onTap: () {
                      BlocProvider.of<PostViewBloc>(context)
                          .selectCategory(index);
                      pagingController.refresh();
                    });
              } else {
                return CategoryItem(
                    label: '🏷️All  ',
                    onTap: () {
                      BlocProvider.of<PostViewBloc>(context).selectCategory(-1);
                      BlocProvider.of<PostViewBloc>(context)
                          .fetchPostsPage(0, pagingController);
                      pagingController.refresh();
                    },
                    isSelected: state.selectedCategoryIndex == -1);
              }
            }),
      ),
    ));
  }
}
