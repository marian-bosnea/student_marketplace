import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/authentication/auth_cubit.dart';
import '../../features/authentication/auth_state.dart';
import '../../features/detailed_post/detailed_post_page.dart';
import '../../features/home/home_page.dart';
import '../../features/login/login_page.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  '/': (context) =>
      BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
        if (authState is Authenticated) {
          return const HomePage();
        } else {
          return AuthenticationPage();
        }
      }),
  '/detailed_post': (context) => DetailedPostPage(
      postId: ModalRoute.of(context)!.settings.arguments as String)
};
