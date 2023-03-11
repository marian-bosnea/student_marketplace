import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_frontend/core/theme/colors.dart';
import 'package:student_marketplace_frontend/features/presentation/detailed_post/detailed_post_cubit.dart';
import 'package:student_marketplace_frontend/features/presentation/detailed_post/detailed_post_page.dart';
import 'package:student_marketplace_frontend/features/presentation/favorites/favorites_view_bloc.dart';
import 'package:student_marketplace_frontend/features/presentation/search/search_view_bloc.dart';

import 'features/presentation/home/home_cubit.dart';
import 'features/presentation/home/home_page.dart';
import 'features/presentation/authentication/auth_cubit.dart';
import 'features/presentation/authentication/auth_state.dart';
import 'features/presentation/login/login_cubit.dart';
import 'features/presentation/login/login_page.dart';
import 'features/presentation/add_post/add_post_cubit.dart';
import 'features/presentation/posts_view/posts_view_cubit.dart';
import 'features/presentation/user_profile/profile_cubit.dart';
import 'features/presentation/register/register_cubit.dart';

import 'core/injection_container.dart' as di;
import 'core/on_generate_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..onAppStarted(context)),
        BlocProvider(create: (_) => di.sl<LoginCubit>()),
        BlocProvider(create: (_) => di.sl<RegisterCubit>()),
        BlocProvider(create: (_) => di.sl<ProfileCubit>()),
        BlocProvider(create: (_) => di.sl<HomeCubit>()),
        BlocProvider(create: (_) => di.sl<PostViewCubit>()),
        BlocProvider(create: (_) => di.sl<AddPostCubit>()),
        BlocProvider(create: (_) => di.sl<DetailedPostCubit>()),
        BlocProvider(create: (_) => di.sl<SearchBloc>()),
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
        routes: {
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
        },
      ),
    );
  }
}
