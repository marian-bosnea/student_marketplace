import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_presentation/core/theme/theme_data.dart';
import 'package:student_marketplace_presentation/core/theme/theme_bloc.dart';
import 'package:student_marketplace_presentation/core/theme/theme_state.dart';
import 'package:student_marketplace_presentation/features/account/account_view_bloc.dart';
import 'package:student_marketplace_presentation/features/address_list_view/own_addresses_view_bloc.dart';
import 'package:student_marketplace_presentation/features/chat_rooms/chat_rooms_view_bloc.dart';
import 'package:student_marketplace_presentation/features/favorites/favorites_view_bloc.dart';
import 'package:student_marketplace_presentation/features/home/home_view_bloc.dart';
import 'package:student_marketplace_presentation/features/orders_view/orders_view_bloc.dart';
import 'package:student_marketplace_presentation/features/own_posts/own_posts_view_bloc.dart';
import 'package:student_marketplace_presentation/features/search_view/search_view_bloc.dart';

import 'core/config/routes.dart';
import 'features/authentication/auth_bloc.dart';
import 'features/login/login_view_bloc.dart';
import 'features/posts_view/posts_view_bloc.dart';
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
        BlocProvider(create: (_) => di.sl<SearchViewBloc>()),
        BlocProvider.value(value: di.sl<PostViewBloc>()),
        BlocProvider(
            create: (_) => di.sl<FavoritesViewBloc>()..fetchFavoritePosts()),
        BlocProvider(create: (_) => di.sl<AccountViewBloc>()),
        BlocProvider(create: (_) => di.sl<HomeViewBloc>()),
        BlocProvider(create: (_) => di.sl<OwnPostsViewBloc>()..fetchOwnPosts()),
        BlocProvider(
            create: (_) => OwnAddressesViewBloc()..fetchAllAddresses()),
        BlocProvider(
          create: (_) => di.sl<OrdersViewBloc>()..fetchSentOrders(),
        ),
        BlocProvider(
          create: (_) => di.sl<ChatRoomsViewBloc>()..init(),
        ),
        BlocProvider(create: (_) => ThemeBloc())
      ],
      child: ScreenUtilInit(
        designSize: const Size(828, 1792),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Student Marketplace',
                debugShowCheckedModeBanner: false,
                onGenerateRoute: OnGenerateRoute.route,
                theme: lightTheme(),
                darkTheme: darkTheme(),
                themeMode: state.themeMode,
                initialRoute: '/',
                routes: appRoutes,
              );
            },
          );
        },
      ),
    );
  }
}
