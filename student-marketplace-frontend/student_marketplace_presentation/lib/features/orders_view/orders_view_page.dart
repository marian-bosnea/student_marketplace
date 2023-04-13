import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_presentation/core/config/injection_container.dart';
import 'package:student_marketplace_presentation/core/theme/colors.dart';
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
                    automaticallyImplyLeading: true,
                    title: const Text('My Orders'),
                  )
                : null,
            body: Material(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomScrollView(
                  slivers: [
                    if (isCupertino(context))
                      const CupertinoSliverNavigationBar(
                        largeTitle: Text('My Orders',
                            style: TextStyle(color: accentColor)),
                        automaticallyImplyLeading: true,
                        previousPageTitle: 'Account',
                      ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: 200,
                        height: 40,
                        child: Center(
                          child: ToggleSwitch(
                            minWidth: 90.0,
                            minHeight: 70.0,
                            cornerRadius: 20.0,
                            initialLabelIndex: state.type.index,
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.white,
                            inactiveFgColor: accentColor,
                            totalSwitches: 2,
                            labels: const ["Sent", "Received"],
                            iconSize: 30.0,
                            borderWidth: 1.0,
                            borderColor: const [accentColor],
                            activeBgColors: const [
                              [accentColor],
                              [accentColor],
                            ],
                            onToggle: (index) =>
                                BlocProvider.of<OrdersViewBloc>(context)
                                    .setViewType(index!),
                          ),
                        ),
                      ),
                    ),
                    _getSelecedList(context, state)
                  ],
                ),
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
              message: "You don't have any sent order",
            ),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
                childCount: state.receivedOrders.length,
                (context, index) => ReceivedOrderListItem(
                      order: state.receivedOrders.elementAt(index),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(PageNames.detailedReceivedOrderPage,
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
