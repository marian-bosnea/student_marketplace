import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:student_marketplace_presentation/features/account/account_view_page.dart';

import '../../core/constants/enums.dart';
import '../../core/theme/colors.dart';
import '../add_post/add_post_view_page.dart';
import '../favorites/favorites_view_page.dart';
import '../posts_view/posts_view_page.dart';
import 'home_view_state.dart';
import 'home_view_bloc.dart';

class HomeViewPage extends StatelessWidget {
  final sl = GetIt.instance;

  HomeViewPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HomeViewBloc>()),
      ],
      child: BlocBuilder<HomeViewBloc, HomePageState>(
        builder: (context, state) {
          return PlatformScaffold(
            iosContentBottomPadding: false,
            iosContentPadding: false,
            cupertino: (context, platform) => CupertinoPageScaffoldData(
                resizeToAvoidBottomInset: false,
                resizeToAvoidBottomInsetTab: false),
            appBar: isMaterial(context)
                ? PlatformAppBar(
                    automaticallyImplyLeading: false,
                    title: PlatformText(
                      state.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black,
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
                  CupertinoTabBarData(activeColor: accentColor),
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                    label: 'Discover',
                    icon: Icon(
                      Icons.explore,
                      color: state.status == HomePageStatus.home
                          ? accentColor
                          : Colors.black38,
                    )),
                BottomNavigationBarItem(
                    label: 'Orders',
                    icon: Icon(
                      Icons.receipt,
                      color: state.status == HomePageStatus.search
                          ? accentColor
                          : Colors.black38,
                    )),
                BottomNavigationBarItem(
                    label: 'Sell',
                    icon: Icon(
                      Icons.sell,
                      color: state.status == HomePageStatus.addPost
                          ? accentColor
                          : Colors.black38,
                    )),
                BottomNavigationBarItem(
                    label: 'Favorites',
                    icon: Icon(
                      Icons.favorite_sharp,
                      color: state.status == HomePageStatus.favorites
                          ? accentColor
                          : Colors.black38,
                    )),
                BottomNavigationBarItem(
                    label: 'Account',
                    icon: Icon(
                      Icons.account_circle,
                      color: state.status == HomePageStatus.profile
                          ? accentColor
                          : Colors.black38,
                    ))
              ],
              itemChanged: (index) => onBottomNavbarItemTap(context, index),
            ),
          );
        },
      ),
    );
  }

  Widget _getNavigationBar(BuildContext context, HomePageState state) {
    return CupertinoSliverNavigationBar(
      largeTitle: Text(
        state.title,
        style: const TextStyle(color: accentColor),
      ),
    );
  }

  onBottomNavbarItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        BlocProvider.of<HomeViewBloc>(context).goToHome(context);
        break;
      case 1:
        BlocProvider.of<HomeViewBloc>(context).goToSearch(context);
        break;
      case 2:
        BlocProvider.of<HomeViewBloc>(context).goToAddPost(context);
        break;
      case 3:
        BlocProvider.of<HomeViewBloc>(context).goToFavorites(context);
        break;
      case 4:
        BlocProvider.of<HomeViewBloc>(context).goToSettings(context);
        break;
    }
  }

  Widget _getCurrentPage(BuildContext context, HomePageState state) {
    switch (state.status) {
      case HomePageStatus.intial:
        return Container();
      case HomePageStatus.home:
        return const PostViewPage();
      case HomePageStatus.search:
        return Container();
      case HomePageStatus.addPost:
        return AddPostPage();
      case HomePageStatus.favorites:
        return FavoritesViewPage();
      case HomePageStatus.profile:
        return AccountViewPage();
    }
  }
}
