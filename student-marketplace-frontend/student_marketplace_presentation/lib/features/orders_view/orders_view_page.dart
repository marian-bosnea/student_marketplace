import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_presentation/core/theme/colors.dart';
import 'package:student_marketplace_presentation/features/orders_view/orders_view_bloc.dart';
import 'package:student_marketplace_presentation/features/orders_view/orders_view_state.dart';
import 'package:student_marketplace_presentation/features/orders_view/widgets/sent_order_list_item.dart';
import 'package:student_marketplace_presentation/features/shared/empty_list_placeholder.dart';
import 'package:toggle_switch/toggle_switch.dart';

class OrdersViewPage extends StatelessWidget {
  const OrdersViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersViewBloc, OrdersViewState>(
      builder: (context, state) {
        return Material(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
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
        );
      },
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
                (context, index) => SentOrderListItem(
                      order: state.receivedOrders.elementAt(index),
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
