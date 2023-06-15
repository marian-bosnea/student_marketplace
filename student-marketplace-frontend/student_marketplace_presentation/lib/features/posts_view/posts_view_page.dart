import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';

import 'package:student_marketplace_presentation/features/posts_view/posts_state.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_view_bloc.dart';
import 'package:student_marketplace_presentation/features/search_view/search_view_bloc.dart';

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
                    // CategoriesList(
                    //   state: state,
                    //   pagingController: _pagingController,
                    // ),
                    CategoriesShowcasePanel(),
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

class CategoriesShowcasePanel extends StatelessWidget {
  final PageController controller = PageController();

  final List<String> categoriesIllustrations = [
    'assets/images/furniture_illustration.png',
    'assets/images/communication_illustration.png',
    'assets/images/sport_illustration.png',
    'assets/images/book_illustration.png',
  ];

  final categoriesGradient = [
    GradientColors.blessingGet,
    GradientColors.coolBlues,
    GradientColors.darkOcean,
    GradientColors.japanBlush,
  ];

  CategoriesShowcasePanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostViewBloc, PostViewState>(
      builder: (context, state) {
        return SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).highlightColor.withAlpha(130),
                    spreadRadius: 4,
                    blurRadius: 2,
                    offset: const Offset(4, 5), // changes position of shadow
                  ),
                ]),
            child: Material(
              elevation: 2,
              type: MaterialType.card,
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).highlightColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: PlatformText(
                        'Browse Categories',
                        style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .color!),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      height: 400,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: controller,
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            final category = state.categories.elementAt(index);
                            return Hero(
                              tag: category.name,
                              child: Material(
                                type: MaterialType.transparency,
                                child: GestureDetector(
                                  onTap: () {
                                    sl
                                        .get<SearchViewBloc>()
                                        .setCategoryId(category.id);
                                    Navigator.of(context)
                                        .pushNamed(RouteNames.search);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: categoriesGradient[index]),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    width:
                                        MediaQuery.of(context).size.width - 60,
                                    //padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 350,
                                            child: Image.asset(
                                              categoriesIllustrations[index],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(25),
                                                    bottomRight:
                                                        Radius.circular(25))),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 70,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(25),
                                                      bottomRight:
                                                          Radius.circular(25)),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 10, sigmaY: 10),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    25),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    25)),
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                  ),
                                                  child: PlatformText(
                                                    category.name,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    if (state.categories != null)
                      SmoothPageIndicator(
                          controller: controller, // PageController
                          count: state.categories.length,
                          effect: WormEffect(
                              activeDotColor: Theme.of(context)
                                  .splashColor), // your preferred effect
                          onDotClicked: (index) {})
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
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

  CategoriesList(
      {super.key, required this.state, required this.pagingController});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Hero(
      tag: 'categories2',
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
