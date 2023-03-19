import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/constants/enums.dart';
import '../../core/theme/colors.dart';
import '../add_post/add_post_view_page.dart';
import '../favorites/favorites_view_page.dart';
import '../posts_view/posts_view_page.dart';
import '../search/search_view_page.dart';
import 'home_view_state.dart';
import 'home_view_bloc.dart';

class HomeViewPage extends StatelessWidget {
  const HomeViewPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeViewBloc, HomePageState>(
      listener: (context, state) async {
        BlocProvider.of<HomeViewBloc>(context).fetchProfilePhoto();

        if (state.status == HomePageStatus.intial) {
          BlocProvider.of<HomeViewBloc>(context).goToHome(context);
        }
      },
      builder: (context, state) {
        return PlatformScaffold(
          cupertino: (context, platform) => CupertinoPageScaffoldData(),
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
                  controller: ScrollController(),
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
                  label: 'Search',
                  icon: Icon(
                    Icons.search,
                    color: state.status == HomePageStatus.search
                        ? accentColor
                        : Colors.black38,
                  )),
              BottomNavigationBarItem(
                  label: 'Post',
                  icon: Icon(
                    Icons.add,
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
                  label: 'Settings',
                  icon: Icon(
                    Icons.settings,
                    color: state.status == HomePageStatus.settings
                        ? accentColor
                        : Colors.black38,
                  ))
            ],
            itemChanged: (index) => onBottomNavbarItemTap(context, index),
          ),
        );
      },
    );
  }

  Widget _getNavigationBar(BuildContext context, HomePageState state) {
    return CupertinoSliverNavigationBar(
      trailing: GestureDetector(
        onTap: () =>
            BlocProvider.of<HomeViewBloc>(context).goToProfile(context),
        child: state.profileIcon != null
            ? CircleAvatar(
                foregroundImage: Image.memory(state.profileIcon!).image,
              )
            : null,
      ),
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
        return PostViewPage();
      case HomePageStatus.search:
        return const SearchViewPage();
      case HomePageStatus.addPost:
        return AddPostPage();
      case HomePageStatus.favorites:
        return const FavoritesViewPage();
      case HomePageStatus.settings:
        return const Center(
          child: Text("Settings Page"),
        );
    }
  }
}
