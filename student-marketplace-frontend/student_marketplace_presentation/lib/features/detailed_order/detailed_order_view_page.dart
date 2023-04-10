import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';
import 'package:student_marketplace_presentation/core/theme/colors.dart';
import 'package:student_marketplace_presentation/features/orders_view/utils/status_data.dart';

class DetailedOrderViewPage extends StatelessWidget {
  final labelStyle =
      TextStyle(fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.w600);

  final groupLabelStyle =
      TextStyle(fontSize: ScreenUtil().setSp(30), color: Colors.black45);

  final infoStyle = TextStyle(fontSize: ScreenUtil().setSp(35));

  final divider = const Divider(
    thickness: 0,
    color: Colors.white,
    height: 20,
  );

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
        message: 'Your product is in the possesion of the shipping company',
        image: SvgPicture.asset('assets/images/order_delivering_art.svg')),
    OrderStatus.delivered: StatusData(
        message:
            'Your product is being delivered to you. Check the AWB for more details',
        image: SvgPicture.asset('assets/images/order_delivered_art.svg'))
  };

  DetailedOrderViewPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: isMaterial(context)
          ? PlatformAppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: true,
              cupertino: ((context, platform) => CupertinoNavigationBarData(
                  automaticallyImplyLeading: true,
                  previousPageTitle: 'Orders')),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomScrollView(slivers: [
          if (isCupertino(context))
            const CupertinoSliverNavigationBar(
              automaticallyImplyLeading: true,
              previousPageTitle: 'Orders',
              largeTitle: Text("Order", style: TextStyle(color: accentColor)),
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
                  style: const TextStyle(color: Colors.black54),
                )
              ]),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Text(
              "Product",
              style: groupLabelStyle,
            ),
            Material(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Product: ',
                          style: labelStyle,
                          maxLines: 2,
                        ),
                        Text(order.objectTitle!, style: infoStyle),
                      ],
                    ),
                    PlatformTextButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.of(context).pushNamed(
                            PageNames.detailedPostPage,
                            arguments: order.objectId),
                        child: Text(
                          'View on Marketplace',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(35),
                              color: accentColor),
                        )),
                  ],
                ),
              ),
            ),
            divider,
            Text(
              "Seller",
              style: groupLabelStyle,
            ),
            Material(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ',
                          style: labelStyle,
                          maxLines: 2,
                        ),
                        Text(order.partnerName!, style: infoStyle),
                      ],
                    ),
                    PlatformTextButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.of(context).pushNamed(
                            PageNames.userProfilePage,
                            arguments: order.partnerId),
                        child: Text(
                          'View Profile',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(35),
                              color: accentColor),
                        ))
                  ],
                ),
              ),
            ),
            divider,
            Text(
              "Delivery",
              style: groupLabelStyle,
            ),
            Material(
              color: Colors.white,
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
                          children: [
                            Text(
                              'Address: ',
                              style: labelStyle,
                              maxLines: 2,
                            ),
                            Text(order.addressDescription!, style: infoStyle),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Status: ', style: labelStyle),
                            Text(_getStatusLabel(order.status),
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(35),
                                    color: _getStatusLabelColor(order.status))),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Last modified: ',
                              style: labelStyle,
                              maxLines: 2,
                            ),
                            Text(order.lastModifiedDate, style: infoStyle),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
            divider,
            Text(
              "Notes",
              style: groupLabelStyle,
            ),
            Material(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(order.notes, style: infoStyle),
              ),
            ),
          ]))
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
