import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/features/create_adress/create_address_view_page.dart';
import 'package:student_marketplace_presentation/features/create_order/create_order_view_page.dart';
import 'package:student_marketplace_presentation/features/detailed_order/awb_form_view_page.dart';
import 'package:student_marketplace_presentation/features/detailed_order/received_detailed_order_view_page.dart';
import 'package:student_marketplace_presentation/features/detailed_order/sent_detailed_order_view_page.dart';
import 'package:student_marketplace_presentation/features/detailed_post/detailed_post_view_page.dart';
import 'package:student_marketplace_presentation/features/edit_post/edit_post_view_page.dart';
import 'package:student_marketplace_presentation/features/home/home_view_page.dart';
import 'package:student_marketplace_presentation/features/messages/messages_view_page.dart';
import 'package:student_marketplace_presentation/features/orders_view/orders_view_page.dart';
import 'package:student_marketplace_presentation/features/settings_view/settings_view_page.dart';
import 'package:student_marketplace_presentation/features/user_profile/user_profile_view_page.dart';

import '../../features/address_list_view/own_addresses_view_page.dart';
import '../../features/login/login_view_page.dart';
import '../../features/register/register_view_page.dart';
import '../../features/account/account_view_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RouteNames.authentication:
        return routeBuilder(LoginViewPage());
      case RouteNames.register:
        return routeBuilder(RegisterViewPage());
      case RouteNames.home:
        return routeBuilder(HomeViewPage());
      case RouteNames.account:
        return routeBuilder(AccountViewPage());
      case RouteNames.editPost:
        assert(args is SalePostEntity);
        return routeBuilder(EditPostViewPage(
          post: args as SalePostEntity,
        ));
      case RouteNames.createAddress:
        return routeBuilder(CreateAddressViewPage(
          addressToEdit: args as AddressEntity?,
        ));
      case RouteNames.userProfile:
        return routeBuilder(UserProfileViewPage(
          userId: args as int,
        ));
      case RouteNames.addressView:
        return routeBuilder(const OwnAddressesViewPage());
      case RouteNames.detailedPost:
        return routeBuilder(DetailedPostViewPage(postId: args as int));
      case RouteNames.ordersView:
        return routeBuilder(const OrdersViewPage());
      case RouteNames.detailedReceivedOrder:
        return routeBuilder(DetailedReceivedOrderViewPage(
          order: args as OrderEntity,
        ));
      case RouteNames.detailedSentOrder:
        return routeBuilder(DetailedSentOrderViewPage(
          order: args as OrderEntity,
        ));
      case RouteNames.createOrder:
        return routeBuilder(CreateOrderViewPage(
          post: args as SalePostEntity,
        ));
      case RouteNames.messages:
        return routeBuilder(MessagesViewPage(
          room: args as ChatRoomEntity,
        ));
      case RouteNames.awbForm:
        return routeBuilder(AwbFormViewPage());
      case RouteNames.settings:
        return routeBuilder(const SettingsViewPage());
      default:
        return routeBuilder(const NoPage());
    }
  }
}

dynamic routeBuilder(Widget page) {
  return MaterialPageRoute(builder: (context) => page);
}

class RouteNames {
  static const authentication = '/';
  static const register = '/register_page';
  static const home = '/home_page';
  static const account = '/account_page';
  static const editPost = '/edit_post_page';
  static const createAddress = '/create_address_page';
  static const addressView = '/addresses_view_page';
  static const ordersView = '/orders_view';
  static const userProfile = '/user_profile_page';
  static const detailedPost = '/detailed_post_page';
  static const detailedReceivedOrder = '/detailed_received_order_page';
  static const detailedSentOrder = '/detailed_sent_order_page';
  static const awbForm = '/awb_form_page';
  static const createOrder = '/create_order_page';
  static const messages = '/messages_page';
  static const settings = '/settings';
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
