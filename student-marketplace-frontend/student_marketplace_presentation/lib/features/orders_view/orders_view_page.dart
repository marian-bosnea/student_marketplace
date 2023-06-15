import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_presentation/core/config/injection_container.dart';
import 'package:student_marketplace_presentation/core/theme/theme_data.dart';
import 'package:student_marketplace_presentation/features/orders_view/orders_view_bloc.dart';
import 'package:student_marketplace_presentation/features/orders_view/orders_view_state.dart';
import 'package:student_marketplace_presentation/features/orders_view/widgets/received_order_list_item.dart';
import 'package:student_marketplace_presentation/features/orders_view/widgets/sent_order_list_item.dart';
import 'package:student_marketplace_presentation/features/shared/empty_list_placeholder.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../core/config/on_generate_route.dart';
import '../own_posts/own_posts_view_bloc.dart';

class OrdersViewPage extends StatelessWidget {
  const OrdersViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OwnPostsViewBloc>(),
      child: BlocBuilder<OrdersViewBloc, OrdersViewState>(
        builder: (context, state) {
          return PlatformScaffold(
            appBar: isMaterial(context)
                ? PlatformAppBar(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    automaticallyImplyLeading: true,
                    title: Text('My Orders',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary)),
                  )
                : null,
            body: Material(
              color: Theme.of(context).colorScheme.surface,
              child: CustomScrollView(
                slivers: [
                  if (isCupertino(context))
                    CupertinoSliverNavigationBar(
                      largeTitle: Text('My Orders',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      automaticallyImplyLeading: true,
                      previousPageTitle: 'Account',
                    ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: 200,
                      height: 40,
                      child: Center(
                        child: ToggleSwitch(
                          minWidth: 90.0,
                          minHeight: 70.0,
                          cornerRadius: 20.0,
                          initialLabelIndex: state.type.index,
                          activeFgColor:
                              Theme.of(context).colorScheme.background,
                          inactiveBgColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          inactiveFgColor:
                              Theme.of(context).colorScheme.primary,
                          totalSwitches: 2,
                          labels: const ["Sent", "Received"],
                          iconSize: 30.0,
                          borderWidth: 1.0,
                          borderColor: [Theme.of(context).colorScheme.outline],
                          activeBgColors: [
                            [Theme.of(context).colorScheme.primary],
                            [Theme.of(context).colorScheme.primary],
                          ],
                          onToggle: (index) =>
                              BlocProvider.of<OrdersViewBloc>(context)
                                  .setViewType(index!),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(10.0),
                    sliver: _getSelecedList(context, state),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getSelecedList(BuildContext context, OrdersViewState state) {
    return state.type == OrdersViewType.received
        ? _getReceivedOrdersWidget(context, state)
        : _getSentOrdersWidget(context, state);
  }

  Widget _getReceivedOrdersWidget(BuildContext context, OrdersViewState state) {
    return state.receivedOrders.isEmpty
        ? const SliverToBoxAdapter(
            child: EmptyListPlaceholder(
              message: "You don't have any received order",
            ),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
                childCount: state.receivedOrders.length,
                (context, index) => ReceivedOrderListItem(
                      order: state.receivedOrders.elementAt(index),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteNames.detailedReceivedOrder,
                                arguments:
                                    state.receivedOrders.elementAt(index))
                            .then((value) {
                          BlocProvider.of<OrdersViewBloc>(context)
                              .fetchReceivedOrders();
                        });
                      },
                    )),
          );
  }

  Widget _getSentOrdersWidget(BuildContext context, OrdersViewState state) {
    return state.sentOrders.isEmpty
        ? const SliverToBoxAdapter(
            child: EmptyListPlaceholder(
              message: "You don't have any sent order",
            ),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
                childCount: state.sentOrders.length,
                (context, index) => SentOrderListItem(
                      order: state.sentOrders.elementAt(index),
                    )),
          );
  }
}
