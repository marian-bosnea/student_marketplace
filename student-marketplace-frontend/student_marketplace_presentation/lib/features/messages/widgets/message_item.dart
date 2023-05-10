import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_business_logic/domain/entities/message_entity.dart';
import 'package:student_marketplace_presentation/core/theme/theme_data.dart';

class MessageItem extends StatelessWidget {
  final bool isOwn;
  final bool hasTail;
  final MessageEntity message;
  const MessageItem(
      {super.key,
      required this.message,
      required this.hasTail,
      required this.isOwn});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: isOwn ? 0 : ScreenUtil().setWidth(500),
          left: !isOwn ? 0 : ScreenUtil().setWidth(500)),
      child: Column(
        crossAxisAlignment:
            isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          BubbleSpecialThree(
            text: message.content,
            color: isOwn
                ? Theme.of(context).highlightColor
                : Theme.of(context).splashColor,
            isSender: isOwn,
            tail: hasTail,
            textStyle: Theme.of(context).textTheme.labelMedium!,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(message.sendTime,
                style: Theme.of(context).textTheme.displaySmall),
          )
        ],
      ),
    );
  }
}
