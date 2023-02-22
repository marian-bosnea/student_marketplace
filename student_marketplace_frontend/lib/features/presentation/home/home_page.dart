import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_frontend/core/enums.dart';
import 'package:student_marketplace_frontend/features/presentation/user_profile/profile_page.dart';

import 'home_cubit.dart';
import 'home_state.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  Widget currentPage = const Center(
    child: Text("Home page"),
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomePageState>(
      listener: (context, state) {},
      builder: (context, state) {
        return PlatformScaffold(
          appBar: PlatformAppBar(
            title: PlatformText(
              "UniTBv Marketplace",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          ),
          body: _getCurrentPage(state),
          bottomNavBar: PlatformNavBar(
            backgroundColor: Colors.black,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home)),
              BottomNavigationBarItem(icon: Icon(Icons.search)),
              BottomNavigationBarItem(icon: Icon(Icons.add)),
              BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle)),
              BottomNavigationBarItem(icon: Icon(Icons.settings))
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
        BlocProvider.of<HomeCubit>(context).goToHome();
        break;
      case 1:
        BlocProvider.of<HomeCubit>(context).goToSearch();
        break;
      case 2:
        BlocProvider.of<HomeCubit>(context).goToAddPost();
        break;
      case 3:
        BlocProvider.of<HomeCubit>(context).goToProfile();
        break;
      case 4:
        BlocProvider.of<HomeCubit>(context).goToSettings();
        break;
    }
  }

  Widget _getCurrentPage(HomePageState state) {
    switch (state.status) {
      case HomePageStatus.home:
        return const Center(
          child: Text("HomePage"),
        );
      case HomePageStatus.search:
        return const Center(
          child: Text("Search Page"),
        );
      case HomePageStatus.addPost:
        return const Center(
          child: Text("Add Post Page"),
        );
      case HomePageStatus.profile:
        return ProfilePage();
      case HomePageStatus.settings:
        return const Center(
          child: Text("Settings Page"),
        );
    }
  }
}
