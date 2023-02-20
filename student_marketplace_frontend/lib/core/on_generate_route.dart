import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../features/presentation/login/login_page.dart';
import '../features/presentation/register/register_page.dart';
import '../features/presentation/user_profile/profile_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case PageNames.authenticationPage:
        return routeBuilder(AuthenticationPage());
      case PageNames.registerPage:
        return routeBuilder(RegisterPage());
      case PageNames.userProfilePage:
        return routeBuilder(const ProfilePage());
      default:
        return routeBuilder(NoPage());
    }
  }
}

class PageNames {
  static const authenticationPage = 'authenticationPage';
  static const registerPage = 'registerPage';
  static const userProfilePage = 'userProfilePage';
}

class NoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
}

dynamic routeBuilder(Widget page) {
  return MaterialPageRoute(builder: (context) => page);
}
