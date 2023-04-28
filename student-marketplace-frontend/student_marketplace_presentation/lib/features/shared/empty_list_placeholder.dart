import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class EmptyListPlaceholder extends StatelessWidget {
  final String message;
  const EmptyListPlaceholder({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: SizedBox(
          height: ScreenUtil().setHeight(1000),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: ScreenUtil().setWidth(500),
                height: ScreenUtil().setHeight(500),
                margin: const EdgeInsets.only(bottom: 20),
                child: SvgPicture.asset('assets/images/empty_list_art.svg'),
              ),
              Text(
                message,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ))),
    );
  }
}
