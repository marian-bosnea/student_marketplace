import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:student_marketplace_presentation/features/account/account_view_page.dart';
import 'package:student_marketplace_presentation/features/chat_rooms/chat_rooms_view_bloc.dart';
import 'package:student_marketplace_presentation/features/chat_rooms/chat_rooms_view_page.dart';

import '../../core/constants/enums.dart';
import '../add_post/add_post_view_page.dart';
import '../favorites/favorites_view_page.dart';
import '../posts_view/posts_view_bloc.dart';
import '../posts_view/posts_view_page.dart';
import 'home_view_state.dart';
import 'home_view_bloc.dart';

class HomeViewPage extends StatelessWidget {
  final sl = GetIt.instance;
  final navBarIconSize = 25.0;
  HomeViewPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewBloc, HomeViewState>(
      builder: (context, state) {
        return PlatformScaffold(
          appBar: isMaterial(context)
              ? PlatformAppBar(
                  automaticallyImplyLeading: false,
                  title: PlatformText(
                    state.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).highlightColor,
                )
              : null,
          body: isCupertino(context)
              ? NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScroller) {
                    return <Widget>[_getNavigationBar(context, state)];
                  },
                  body: _getCurrentPage(context, state))
              : _getCurrentPage(context, state),
          bottomNavBar: PlatformNavBar(
            cupertino: (context, platform) =>
                CupertinoTabBarData(activeColor: Theme.of(context).splashColor),
            backgroundColor: Theme.of(context).primaryColor,
            items: [
              BottomNavigationBarItem(
                  label: 'Discover',
                  icon: Icon(
                      size: navBarIconSize,
                      FontAwesomeIcons.solidCompass,
                      color: state.status == HomePageStatus.home
                          ? Theme.of(context).splashColor
                          : Theme.of(context).textTheme.displayMedium!.color)),
              BottomNavigationBarItem(
                  label: 'Messages',
                  icon: Icon(FontAwesomeIcons.solidMessage,
                      size: navBarIconSize,
                      color: state.status == HomePageStatus.messages
                          ? Theme.of(context).splashColor
                          : Theme.of(context).textTheme.displayMedium!.color)),
              BottomNavigationBarItem(
                  label: 'Sell',
                  icon: Icon(FontAwesomeIcons.plus,
                      size: navBarIconSize,
                      color: state.status == HomePageStatus.addPost
                          ? Theme.of(context).splashColor
                          : Theme.of(context).textTheme.displayMedium!.color)),
              BottomNavigationBarItem(
                  label: 'Favorites',
                  icon: Icon(
                    FontAwesomeIcons.solidHeart,
                    size: navBarIconSize,
                    color: state.status == HomePageStatus.favorites
                        ? Theme.of(context).splashColor
                        : Theme.of(context).textTheme.displayMedium!.color,
                  )),
              BottomNavigationBarItem(
                  label: 'Profile',
                  icon: Icon(
                    FontAwesomeIcons.solidUser,
                    size: navBarIconSize,
                    color: state.status == HomePageStatus.account
                        ? Theme.of(context).splashColor
                        : Theme.of(context).textTheme.displayMedium!.color,
                  ))
            ],
            itemChanged: (index) => onBottomNavbarItemTap(context, index),
          ),
        );
      },
    );
  }

  Widget _getNavigationBar(BuildContext context, HomeViewState state) {
    final postsBloc = BlocProvider.of<PostViewBloc>(context);
    return CupertinoSliverNavigationBar(
      alwaysShowMiddle: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).highlightColor,
      largeTitle: state.status == HomePageStatus.home
          ? Row(
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: ScreenUtil().setHeight(80),
                    width: ScreenUtil().setWidth(690),
                    child: PlatformTextField(
                        hintText: state.searchHint,
                        onChanged: (text) =>
                            postsBloc.onSearchQueryChanged(text),
                        cupertino: (context, target) =>
                            _searchCupertinoTextFieldData(context),
                        onSubmitted: (text) =>
                            postsBloc.fetchAllPostsByTextQuery(text))),
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).splashColor,
                      border: Border.all(color: Colors.black12),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  height: ScreenUtil().setHeight(80),
                  width: ScreenUtil().setWidth(80),
                  child: Center(
                    child: Icon(
                      Icons.category,
                      color: Colors.white,
                      size: ScreenUtil().setHeight(50),
                    ),
                  ),
                ),
              ],
            )
          : Text(
              state.title,
              style: TextStyle(color: Theme.of(context).splashColor),
            ),
    );
  }

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

  onBottomNavbarItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        BlocProvider.of<HomeViewBloc>(context).goToHome();
        break;
      case 1:
        BlocProvider.of<HomeViewBloc>(context).goToOrders();
        break;
      case 2:
        BlocProvider.of<HomeViewBloc>(context).goToAddPost();
        break;
      case 3:
        BlocProvider.of<HomeViewBloc>(context).goToFavorites();
        break;
      case 4:
        BlocProvider.of<HomeViewBloc>(context).goToAccount();
        break;
    }
  }

  Widget _getCurrentPage(BuildContext context, HomeViewState state) {
    switch (state.status) {
      case HomePageStatus.intial:
        return Container();
      case HomePageStatus.home:
        return const PostViewPage();
      case HomePageStatus.messages:
        BlocProvider.of<ChatRoomsViewBloc>(context).init();
        return ChatRoomsViewPage();
      case HomePageStatus.addPost:
        return AddPostPage();
      case HomePageStatus.favorites:
        return FavoritesViewPage();
      case HomePageStatus.account:
        return AccountViewPage();
    }
  }
}
