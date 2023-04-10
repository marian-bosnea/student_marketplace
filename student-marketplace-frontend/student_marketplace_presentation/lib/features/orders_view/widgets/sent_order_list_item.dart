import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_presentation/core/theme/colors.dart';
import 'package:student_marketplace_presentation/features/detailed_order/detailed_order_view_page.dart';

class SentOrderListItem extends StatelessWidget {
  final OrderEntity order;

  final labelStyle =
      TextStyle(fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.w600);
  final infoStyle = TextStyle(fontSize: ScreenUtil().setSp(30));

  SentOrderListItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 500),
      openShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      closedBuilder: (BuildContext context, void Function() action) {
        return Material(
          elevation: 1,
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
            padding: const EdgeInsets.all(10),
            height: ScreenUtil().setHeight(200),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        "Order: ",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        order.objectTitle!,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Last modified: ',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Colors.black54)),
                      Text(order.lastModifiedDate,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Colors.black54)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Status: ', style: labelStyle),
                      Text(_getStatusLabel(order.status),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: _getStatusLabelColor(order.status))),
                    ],
                  ),
                ]),
          ),
        );
      },
      openBuilder:
          (BuildContext context, void Function({Object? returnValue}) action) {
        return DetailedOrderViewPage(
          order: order,
        );
      },
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
