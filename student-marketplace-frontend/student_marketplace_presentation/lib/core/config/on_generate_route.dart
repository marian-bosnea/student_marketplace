import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/features/create_adress/create_address_view_page.dart';
import 'package:student_marketplace_presentation/features/detailed_post/detailed_post_view_page.dart';
import 'package:student_marketplace_presentation/features/edit_post/edit_post_view_page.dart';
import 'package:student_marketplace_presentation/features/home/home_view_page.dart';
import 'package:student_marketplace_presentation/features/orders_view/orders_view_page.dart';
import 'package:student_marketplace_presentation/features/user_profile/user_profile_view_page.dart';

import '../../features/address_list_view/own_addresses_view_page.dart';
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
      case PageNames.accountPage:
        return routeBuilder(AccountViewPage());
      case PageNames.editPostPage:
        assert(args is SalePostEntity);
        return routeBuilder(EditPostViewPage(
          post: args as SalePostEntity,
        ));
      case PageNames.createAddress:
        return routeBuilder(CreateAddressViewPage(
          addressToEdit: args as AddressEntity?,
        ));
      case PageNames.userProfilePage:
        return routeBuilder(UserProfileViewPage(
          userId: args as int,
        ));
      case PageNames.addressView:
        return routeBuilder(const OwnAddressesViewPage());
      case PageNames.detailedPostPage:
        return routeBuilder(DetailedPostViewPage(postId: args as int));
      case PageNames.ordersView:
        return routeBuilder(OrdersViewPage());
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
  static const accountPage = 'accountPage';
  static const editPostPage = 'editPostPage';
  static const createAddress = 'createAddressPage';
  static const addressView = 'addressesViewPage';
  static const ordersView = 'ordersView';
  static const userProfilePage = 'userProfilePage';
  static const detailedPostPage = 'detailedPostPage';
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
