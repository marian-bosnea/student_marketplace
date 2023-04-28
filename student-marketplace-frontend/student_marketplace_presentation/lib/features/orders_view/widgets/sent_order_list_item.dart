import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';
import 'package:student_marketplace_presentation/features/orders_view/widgets/status_styles.dart';

class SentOrderListItem extends StatelessWidget {
  final OrderEntity order;

  final labelStyle =
      TextStyle(fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.w600);
  final infoStyle = TextStyle(fontSize: ScreenUtil().setSp(30));

  SentOrderListItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(RouteNames.detailedSentOrder, arguments: order),
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        child: Material(
          elevation: 1,
          color: Theme.of(context).highlightColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black12),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.all(10),
            height: ScreenUtil().setHeight(200),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Icon(
                    getStatusIcon(order.status),
                    color: getStatusLabelColor(order.status),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text(
                              order.objectTitle!,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                        Text(getStatusLabel(order.status),
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                                color: getStatusLabelColor(order.status))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Last modified: ${order.lastModifiedDate} ',
                                style:
                                    Theme.of(context).textTheme.displayMedium),
                          ],
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
