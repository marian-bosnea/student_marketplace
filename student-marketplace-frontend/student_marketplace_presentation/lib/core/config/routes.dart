import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_presentation/features/account/account_view_bloc.dart';

import 'package:student_marketplace_presentation/features/account/account_view_page.dart';
import 'package:student_marketplace_presentation/features/create_adress/create_address_view_page.dart';
import 'package:student_marketplace_presentation/features/edit_post/edit_post_view_page.dart';
import 'package:student_marketplace_presentation/features/favorites/favorites_view_bloc.dart';
import 'package:student_marketplace_presentation/features/own_posts/own_posts_view_page.dart';

import '../../features/authentication/auth_bloc.dart';
import '../../features/authentication/auth_state.dart';
import '../../features/detailed_post/detailed_post_view_page.dart';
import '../../features/home/home_view_page.dart';
import '../../features/login/login_view_page.dart';
import '../../features/posts_view/posts_view_bloc.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  '/': (context) =>
      BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
        if (authState.status == AuthStatus.authenticated) {
          //BlocProvider.of<PostViewBloc>(context).fetchAllPosts();
          BlocProvider.of<PostViewBloc>(context).fetchAllCategories();
          BlocProvider.of<FavoritesViewBloc>(context).fetchFavoritePosts();
          BlocProvider.of<AccountViewBloc>(context).fetchUserProfile(0);
          return HomeViewPage();
        } else {
          return LoginViewPage();
        }
      }),
  '/detailed_post': (context) => DetailedPostViewPage(
      postId: ModalRoute.of(context)!.settings.arguments as int),
  '/user_profile': (context) => AccountViewPage(),
  '/own_posts': (context) => OwnPostsViewPage(),
};
