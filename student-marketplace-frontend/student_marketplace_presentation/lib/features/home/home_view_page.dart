import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:student_marketplace_presentation/features/account/account_view_page.dart';
import 'package:student_marketplace_presentation/features/chat_rooms/chat_rooms_view_page.dart';
import 'package:student_marketplace_presentation/features/favorites/favorites_view_bloc.dart';

import '../add_post/add_post_view_page.dart';
import '../favorites/favorites_view_page.dart';
import '../posts_view/posts_view_page.dart';
import 'home_view_state.dart';
import 'home_view_bloc.dart';

class HomeViewPage extends StatefulWidget {
  const HomeViewPage({super.key});

  @override
  State<HomeViewPage> createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeViewPage> {
  final sl = GetIt.instance;

  final navBarIconSize = 25.0;
  late List<Widget> _pages;
  late HomeViewBloc _pageBloc;

  @override
  void initState() {
    _pageBloc = sl.call<HomeViewBloc>();
    _pages = [
      const PostViewPage(),
      const ChatRoomsViewPage(),
      AddPostPage(),
      FavoritesViewPage(),
      AccountViewPage()
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewBloc, HomeViewState>(
      bloc: _pageBloc,
      builder: (context, state) {
        return PlatformScaffold(
          // appBar: PlatformAppBar(
          //   automaticallyImplyLeading: false,
          //   title: PlatformText(
          //     state.title,
          //     style: TextStyle(color: Theme.of(context).splashColor),
          //   ),
          //   backgroundColor: Theme.of(context).highlightColor,
          // ),
          body: SafeArea(
            child: IndexedStack(
              index: state.currentPageIndex,
              children: _pages,
            ),
          ),
          bottomNavBar: PlatformNavBar(
            material: (context, platform) => MaterialNavBarData(
                unselectedItemColor:
                    Theme.of(context).colorScheme.onSurfaceVariant,
                selectedItemColor: Theme.of(context).colorScheme.tertiary,
                currentIndex: state.currentPageIndex,
                backgroundColor:
                    Theme.of(context).colorScheme.tertiaryContainer,
                itemChanged: (index) {
                  BlocProvider.of<FavoritesViewBloc>(context)
                      .fetchFavoritePosts();
                  _pageBloc.setCurrentPageIndex(index);
                }),
            cupertino: (context, platform) => CupertinoTabBarData(
                activeColor: Theme.of(context).colorScheme.onPrimaryContainer),
            items: [
              BottomNavigationBarItem(
                  label: 'Discover',
                  icon: Icon(
                      size: navBarIconSize,
                      FontAwesomeIcons.solidCompass,
                      color: state.currentPageIndex == 0
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onSurfaceVariant)),
              BottomNavigationBarItem(
                  label: 'Messages',
                  icon: Icon(FontAwesomeIcons.solidMessage,
                      size: navBarIconSize,
                      color: state.currentPageIndex == 1
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onSurfaceVariant)),
              BottomNavigationBarItem(
                  label: 'Sell',
                  icon: Icon(FontAwesomeIcons.plus,
                      size: navBarIconSize,
                      color: state.currentPageIndex == 2
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onSurfaceVariant)),
              BottomNavigationBarItem(
                  label: 'Favorites',
                  icon: Icon(FontAwesomeIcons.solidHeart,
                      size: navBarIconSize,
                      color: state.currentPageIndex == 3
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onSurfaceVariant)),
              BottomNavigationBarItem(
                  label: 'Profile',
                  icon: Icon(
                    FontAwesomeIcons.solidUser,
                    size: navBarIconSize,
                    color: state.currentPageIndex == 4
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ))
            ],
            itemChanged: (index) {
              BlocProvider.of<FavoritesViewBloc>(context).fetchFavoritePosts();
              _pageBloc.setCurrentPageIndex(index);
            },
          ),
        );
      },
    );
  }

  // Widget _getNavigationBar(BuildContext context, HomeViewState state) {
  //   final postsBloc = BlocProvider.of<PostViewBloc>(context);
  //   return CupertinoSliverNavigationBar(
  //     alwaysShowMiddle: false,
  //     automaticallyImplyLeading: false,
  //     backgroundColor: Theme.of(context).highlightColor,
  //     largeTitle: state.currentPageIndex == 0
  //         ? Row(
  //             children: [
  //               Container(
  //                   padding: const EdgeInsets.only(left: 10, right: 10),
  //                   height: ScreenUtil().setHeight(80),
  //                   width: ScreenUtil().setWidth(690),
  //                   child: PlatformTextField(
  //                       hintText: state.searchHint,
  //                       onChanged: (text) =>
  //                           postsBloc.onSearchQueryChanged(text),
  //                       cupertino: (context, target) =>
  //                           _searchCupertinoTextFieldData(context),
  //                       onSubmitted: (text) =>
  //                           postsBloc.fetchAllPostsByTextQuery(text))),
  //               Container(
  //                 padding: const EdgeInsets.all(5),
  //                 margin: const EdgeInsets.only(right: 10),
  //                 decoration: BoxDecoration(
  //                     color: Theme.of(context).splashColor,
  //                     border: Border.all(color: Colors.black12),
  //                     borderRadius:
  //                         const BorderRadius.all(Radius.circular(10))),
  //                 height: ScreenUtil().setHeight(80),
  //                 width: ScreenUtil().setWidth(80),
  //                 child: Center(
  //                   child: Icon(
  //                     Icons.category,
  //                     color: Colors.white,
  //                     size: ScreenUtil().setHeight(50),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           )
  //         : Text(
  //             state.title,
  //             style: TextStyle(color: Theme.of(context).splashColor),
  //           ),
  //   );
  // }

  CupertinoTextFieldData _searchCupertinoTextFieldData(BuildContext context) {
    return CupertinoTextFieldData(
      padding: const EdgeInsets.only(left: 10),
      prefix: SizedBox(
        width: 30,
        height: 30,
        child: Icon(
          CupertinoIcons.search,
          color: Theme.of(context).splashColor,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.black12)),
    );
  }
}
