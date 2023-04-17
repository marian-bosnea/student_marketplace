import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';

class ReceivedOrderListItem extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onTap;

  final labelStyle =
      TextStyle(fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.w600);
  final infoStyle = TextStyle(fontSize: ScreenUtil().setSp(30));

  ReceivedOrderListItem({super.key, required this.onTap, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black12),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.all(10),
        height: ScreenUtil().setHeight(200),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.objectTitle!,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(40),
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  Text('#${order.id}')
                ],
              ),
              Text(_getStatusLabel(order.status),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(30),
                      color: _getStatusLabelColor(order.status))),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: ScreenUtil().setWidth(700),
                    child: Text(order.addressDescription!,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Colors.black54)),
                  ),
                ],
              ),
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
