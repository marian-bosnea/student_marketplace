import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/routes.dart';
import 'core/theme/colors.dart';
import 'features/detailed_post/detailed_post_view_bloc.dart';
import 'features/favorites/favorites_view_bloc.dart';
import 'features/home/home_view_bloc.dart';
import 'features/authentication/auth_bloc.dart';
import 'features/login/login_view_bloc.dart';
import 'features/add_post/add_post_view_bloc.dart';
import 'features/posts_view/posts_view_cubit.dart';
import 'features/search/search_view_bloc.dart';
import 'features/user_profile/profile_view_bloc.dart';
import 'features/register/register_view_bloc.dart';

import 'core/config/injection_container.dart' as di;
import 'core/config/on_generate_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const StudentMarketPlace());
}

class StudentMarketPlace extends StatelessWidget {
  const StudentMarketPlace({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()..onAppStarted(context)),
        BlocProvider(create: (_) => di.sl<LoginViewBloc>()),
        BlocProvider(create: (_) => di.sl<RegisterViewBloc>()),
        BlocProvider(create: (_) => di.sl<ProfileViewBloc>()),
        BlocProvider(create: (_) => di.sl<HomeViewBloc>()),
        BlocProvider(create: (_) => di.sl<PostViewCubit>()),
        BlocProvider(create: (_) => di.sl<AddPostViewBloc>()),
        BlocProvider(create: (_) => di.sl<DetailedPostViewBloc>()),
        BlocProvider(create: (_) => di.sl<SearchViewBloc>()),
        BlocProvider(create: (_) => di.sl<FavoritesViewBloc>())
      ],
      child: MaterialApp(
        title: 'Student Marketplace',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: OnGenerateRoute.route,
        theme: ThemeData(
          textTheme: const TextTheme(labelSmall: TextStyle(color: accentColor)),
        ),
        initialRoute: '/',
        routes: appRoutes,
      ),
    );
  }
}
