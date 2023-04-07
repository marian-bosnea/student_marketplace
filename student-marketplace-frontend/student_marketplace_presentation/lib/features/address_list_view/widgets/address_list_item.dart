import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';

class AddressListItem extends StatelessWidget {
  final AddressEntity address;

  const AddressListItem({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, top: 5),
      height: ScreenUtil().setHeight(300),
      //width: ScreenUtil().setWidth(500),
      child: Material(
        color: Colors.white,
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Text(
              address.name,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(50),
                  fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Text(
                  'County: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil().setSp(35)),
                ),
                Text(
                  address.county,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil().setHeight(35)),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'City: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil().setSp(35)),
                ),
                Text(
                  address.city,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil().setHeight(35)),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'Address: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil().setSp(35)),
                ),
                Text(
                  address.description,
                  maxLines: 3,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil().setHeight(35)),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
