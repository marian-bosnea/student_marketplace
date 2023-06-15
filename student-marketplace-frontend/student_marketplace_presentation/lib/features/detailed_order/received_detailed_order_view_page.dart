import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';
import 'package:student_marketplace_presentation/core/theme/theme_data.dart';
import 'package:student_marketplace_presentation/features/detailed_order/received_detailed_order_view_bloc.dart';
import 'package:student_marketplace_presentation/features/detailed_order/received_detailed_order_view_state.dart';
import 'package:student_marketplace_presentation/features/orders_view/orders_view_bloc.dart';
import 'package:student_marketplace_presentation/features/shared/list_action_item.dart';

import '../../core/config/injection_container.dart';

class DetailedReceivedOrderViewPage extends StatelessWidget {
  final OrderEntity order;
  final ordersViewBloc = sl<OrdersViewBloc>();
  DetailedReceivedOrderViewPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReceivedDetailedOrderViewBloc()
        ..init(order.id!, order.status, order.awb!, order.lastModifiedDate),
      child: BlocBuilder<ReceivedDetailedOrderViewBloc,
          ReceivedDetailedOrderViewState>(
        builder: (context, state) {
          return Material(
            child: PlatformScaffold(
              backgroundColor: Theme.of(context).primaryColor,
              appBar: isMaterial(context)
                  ? PlatformAppBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      automaticallyImplyLeading: true,
                      cupertino: ((context, platform) =>
                          CupertinoNavigationBarData(
                              automaticallyImplyLeading: true,
                              previousPageTitle: 'Orders')),
                    )
                  : null,
              body: CustomScrollView(slivers: [
                if (isCupertino(context))
                  CupertinoSliverNavigationBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    automaticallyImplyLeading: true,
                    previousPageTitle: 'Orders',
                    largeTitle: Text("Order",
                        style: TextStyle(color: Theme.of(context).splashColor)),
                  ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    margin: const EdgeInsets.all(5),
                    child: Text(
                      "Number #${order.id}",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    Text(
                      "Shipping",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Material(
                      color: Theme.of(context).highlightColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: ScreenUtil().setHeight(200),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Address: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                      maxLines: 2,
                                    ),
                                    SizedBox(
                                        width: ScreenUtil().setWidth(600),
                                        child: Text(order.addressDescription!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Status: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                    Text(_getStatusLabel(state.orderStatus),
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(35),
                                            color: _getStatusLabelColor(
                                                state.orderStatus))),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Last modified: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                      maxLines: 2,
                                    ),
                                    Text(state.lastModifiedDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ),
                    Text(
                      "Product",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Material(
                      color: Theme.of(context).highlightColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed(
                                  RouteNames.detailedPost,
                                  arguments: order.objectId),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(order.objectTitle!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium),
                                  const Icon(Icons.chevron_right)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "Buyer",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Material(
                      color: Theme.of(context).highlightColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed(
                                  RouteNames.userProfile,
                                  arguments: order.partnerId),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(order.partnerName!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium),
                                  const Icon(Icons.chevron_right)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "Notes",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Material(
                      color: Theme.of(context).highlightColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(order.notes),
                      ),
                    ),
                    Text(
                      "Action",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: _getAction(context, state.orderStatus),
                      ),
                    )
                  ])),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  _getAction(BuildContext context, OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return _getPendingAction(context);
      case OrderStatus.accepted:
        return _getAcceptedAction(context);
      case OrderStatus.declined:
        return _getDeclinedAction(context);
      case OrderStatus.toCourier:
        return _getDeliveringAction(context);

      case OrderStatus.delivered:
        // TODO: Handle this case.
        break;
    }
  }

  Widget _getPendingAction(BuildContext context) {
    final pageBloc = BlocProvider.of<ReceivedDetailedOrderViewBloc>(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            "Decide whether you want agree to ship your product to this address.",
            style: TextStyle(color: Colors.black54),
          ),
          ListActionItem(
            color: Colors.green,
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            label: 'Accept',
            onTap: () {
              pageBloc.setStatus(OrderStatus.accepted);
            },
          ),
          ListActionItem(
            color: Colors.red,
            isLast: true,
            icon: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            label: 'Decline',
            onTap: () {
              pageBloc.setStatus(OrderStatus.declined);
            },
          ),
        ],
      ),
    );
  }

  Widget _getAcceptedAction(BuildContext context) {
    final pageBloc = BlocProvider.of<ReceivedDetailedOrderViewBloc>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            "After you give the package to the courier, make sure you submit AWB to let your buyer know about status of the shipping.",
            style: TextStyle(color: Colors.black54),
          ),
          ListActionItem(
              color: Colors.blue,
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              hasTrailing: true,
              isLast: true,
              label: 'Enter AWB',
              onTap: () async {
                final awb =
                    await Navigator.of(context).pushNamed(RouteNames.awbForm);

                if (awb == null) return;

                pageBloc.setAWB(awb as String);
              }),
        ],
      ),
    );
  }

  Widget _getDeclinedAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Text(
            "You have declined this order",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _getDeliveringAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Text(
            "No action needed",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';

      case OrderStatus.accepted:
        return 'Accepted';

      case OrderStatus.declined:
        return 'Declined';

      case OrderStatus.toCourier:
        return 'Delivering';

      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color _getStatusLabelColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.yellow;

      case OrderStatus.accepted:
        return Colors.green;

      case OrderStatus.declined:
        return Colors.red;

      case OrderStatus.toCourier:
        return Colors.blue;

      case OrderStatus.delivered:
        return Colors.black;
    }
  }
}
