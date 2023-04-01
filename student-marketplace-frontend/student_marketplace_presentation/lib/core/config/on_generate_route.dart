import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/features/edit_post/edit_post_view_page.dart';
import 'package:student_marketplace_presentation/features/home/home_view_page.dart';

import '../../features/login/login_view_page.dart';
import '../../features/register/register_view_page.dart';
import '../../features/account/account_view_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PageNames.authenticationPage:
        return routeBuilder(LoginViewPage());
      case PageNames.registerPage:
        return routeBuilder(RegisterViewPage());
      case PageNames.homePage:
        return routeBuilder(HomeViewPage());
      case PageNames.userProfilePage:
        return routeBuilder(AccountViewPage());
      case PageNames.editPostPage:
        assert(args is SalePostEntity);
        return routeBuilder(EditPostViewPage(
          post: args as SalePostEntity,
        ));
      default:
        return routeBuilder(const NoPage());
    }
  }
}

dynamic routeBuilder(Widget page) {
  return MaterialPageRoute(builder: (context) => page);
}

class PageNames {
  static const homePage = 'homePage';
  static const authenticationPage = 'authenticationPage';
  static const registerPage = 'registerPage';
  static const userProfilePage = 'userProfilePage';
  static const editPostPage = 'editPostPage';
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
