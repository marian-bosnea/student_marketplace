import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListActionItem extends StatelessWidget {
  final Icon icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final bool hasTrailing;
  final bool isLast;

  const ListActionItem(
      {super.key,
      required this.icon,
      required this.color,
      required this.label,
      required this.onTap,
      this.isLast = false,
      this.hasTrailing = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: icon,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(35),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      if (hasTrailing)
                        Icon(
                          Icons.chevron_right,
                          color: color,
                        )
                    ],
                  )
                ],
              ),
            ),
            if (!isLast)
              const Divider(
                indent: 50,
              )
          ],
        ),
      ),
    );
  }
}
