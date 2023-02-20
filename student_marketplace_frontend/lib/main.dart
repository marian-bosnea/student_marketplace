import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'core/injection_container.dart' as di;
import 'core/on_generate_route.dart';
import 'features/presentation/authentication/auth_cubit.dart';
import 'features/presentation/authentication/auth_state.dart';
import 'features/presentation/login/login_cubit.dart';
import 'features/presentation/login/login_page.dart';
import 'features/presentation/user_profile/profile_page.dart';

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
      ],
      child: PlatformApp(
        title: 'Student Marketplace',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: '/',
        routes: {
          '/': (context) =>
              BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
                if (authState is Authenticated) {
                  return ProfilePage();
                } else {
                  return AuthenticationPage();
                }
              })
        },
      ),
    );
  }
}
