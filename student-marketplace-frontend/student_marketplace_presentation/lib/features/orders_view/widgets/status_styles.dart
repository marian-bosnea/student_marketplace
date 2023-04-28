import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';

IconData getStatusIcon(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return FontAwesomeIcons.solidClock;

    case OrderStatus.accepted:
      return FontAwesomeIcons.check;

    case OrderStatus.declined:
      return FontAwesomeIcons.x;

    case OrderStatus.toCourier:
      return FontAwesomeIcons.truck;

    case OrderStatus.delivered:
      return FontAwesomeIcons.box;
      ;
  }
}

getStatusLabel(OrderStatus status) {
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

Color getStatusLabelColor(OrderStatus status) {
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
