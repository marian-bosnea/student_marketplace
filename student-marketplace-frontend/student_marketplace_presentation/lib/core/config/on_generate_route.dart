import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../features/login/login_view_page.dart';
import '../../features/register/register_view_page.dart';
import '../../features/account/account_view_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    //final args = settings.arguments;
    switch (settings.name) {
      case PageNames.authenticationPage:
        return routeBuilder(LoginViewPage());
      case PageNames.registerPage:
        return routeBuilder(RegisterViewPage());
      case PageNames.userProfilePage:
        return routeBuilder(AccountViewPage());
      default:
        return routeBuilder(const NoPage());
    }
  }
}

dynamic routeBuilder(Widget page) {
  return MaterialPageRoute(builder: (context) => page);
}

class PageNames {
  static const authenticationPage = 'authenticationPage';
  static const registerPage = 'registerPage';
  static const userProfilePage = 'userProfilePage';
}

class NoPage extends StatelessWidget {
  const NoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
}
