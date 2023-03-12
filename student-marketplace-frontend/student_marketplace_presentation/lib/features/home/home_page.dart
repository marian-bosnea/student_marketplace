import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/constants/enums.dart';
import '../../core/theme/colors.dart';
import '../add_post/add_post_page.dart';
import '../favorites/favorites_view_page.dart';
import '../posts_view/posts_view_page.dart';
import '../search/search_view_page.dart';
import 'home_page_bloc.dart';
import 'home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  _init(BuildContext context) async {
    BlocProvider.of<HomePageBloc>(context).fetchProfilePhoto();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
      listener: (context, state) {},
      builder: (context, state) {
        _init(context);

        return PlatformScaffold(
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
                    return <Widget>[
                      CupertinoSliverNavigationBar(
                        trailing: state.profileIcon != null
                            ? GestureDetector(
                                onTap: () =>
                                    BlocProvider.of<HomePageBloc>(context)
                                        .goToProfile(context),
                                child: CircleAvatar(
                                  foregroundImage:
                                      Image.memory(state.profileIcon!).image,
                                ),
                              )
                            : null,
                        largeTitle: Text(
                          state.title,
                          style: const TextStyle(color: accentColor),
                        ),
                      )
                    ];
                  },
                  body: _getCurrentPage(context, state))
              : _getCurrentPage(context, state),
          bottomNavBar: PlatformNavBar(
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

  onBottomNavbarItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        BlocProvider.of<HomePageBloc>(context).goToHome();
        break;
      case 1:
        BlocProvider.of<HomePageBloc>(context).goToSearch();
        break;
      case 2:
        BlocProvider.of<HomePageBloc>(context).goToAddPost();
        break;
      case 3:
        BlocProvider.of<HomePageBloc>(context).goToFavorites();
        break;
      case 4:
        BlocProvider.of<HomePageBloc>(context).goToSettings();
        break;
    }
  }

  Widget _getCurrentPage(BuildContext context, HomePageState state) {
    switch (state.status) {
      case HomePageStatus.home:
        return PostViewPage();
      case HomePageStatus.search:
        return const SearchPage();
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
