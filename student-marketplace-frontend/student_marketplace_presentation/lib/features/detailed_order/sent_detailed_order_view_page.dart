import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';
import 'package:student_marketplace_presentation/core/theme/colors.dart';
import 'package:student_marketplace_presentation/features/orders_view/utils/status_data.dart';

class DetailedSentOrderViewPage extends StatelessWidget {
  final OrderEntity order;

  final statusesData = {
    OrderStatus.pending: StatusData(
        message:
            'Your order has been sent to the seller, waiting for his approval',
        image: SvgPicture.asset('assets/images/order_pending_art.svg')),
    OrderStatus.accepted: StatusData(
        message:
            'Your order has been accepted by the seller, soon you will get AWB to track your shipping',
        image: SvgPicture.asset('assets/images/order_accepted_art.svg')),
    OrderStatus.declined: StatusData(
        message: 'Your order has been declined by the seller',
        image: SvgPicture.asset('assets/images/order_declined_art.svg')),
    OrderStatus.toCourier: StatusData(
        message:
            'Your product is being delivered to you. Check the AWB for more details',
        image: SvgPicture.asset('assets/images/order_delivering_art.svg')),
    OrderStatus.delivered: StatusData(
        message: 'Your product has been delivered to you',
        image: SvgPicture.asset('assets/images/order_delivered_art.svg'))
  };

  DetailedSentOrderViewPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: isMaterial(context)
          ? PlatformAppBar(
              backgroundColor: Theme.of(context).primaryColor,
              automaticallyImplyLeading: true,
              cupertino: ((context, platform) => CupertinoNavigationBarData(
                  automaticallyImplyLeading: true,
                  previousPageTitle: 'Orders')),
            )
          : null,
      body: Material(
        color: Theme.of(context).primaryColor,
        child: CustomScrollView(slivers: [
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
              padding: const EdgeInsets.all(20),
              height: ScreenUtil().setHeight(500),
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: ScreenUtil().setHeight(300),
                  child: statusesData[order.status]!.image,
                ),
                Text(
                  statusesData[order.status]!.message,
                  style: Theme.of(context).textTheme.displayMedium,
                )
              ]),
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
                    height: ScreenUtil().setHeight(220),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Address: ',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                                maxLines: 2,
                              ),
                              Text(order.addressDescription!,
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Status: ',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              Text(_getStatusLabel(order.status),
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(35),
                                      color:
                                          _getStatusLabelColor(order.status))),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Last modified: ',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                                maxLines: 2,
                              ),
                              Text(
                                order.lastModifiedDate,
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ],
                          ),
                          if (order.awb!.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'AWB: ',
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                  maxLines: 2,
                                ),
                                Text(
                                  order.awb!,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                PlatformIconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      FontAwesomeIcons.copy,
                                      color: Theme.of(context).splashColor,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      await Clipboard.setData(
                                          ClipboardData(text: order.awb!));
                                    })
                              ],
                            ),
                        ]),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.objectTitle!,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Seller",
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.partnerName!,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
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
            ])),
          )
        ]),
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
        return Colors.orange;

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
