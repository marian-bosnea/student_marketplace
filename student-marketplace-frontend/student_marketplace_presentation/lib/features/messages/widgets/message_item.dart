import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_business_logic/domain/entities/message_entity.dart';
import 'package:student_marketplace_presentation/core/theme/colors.dart';

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
            color: isOwn ? const Color(0xFFE8E8EE) : accentColor,
            isSender: isOwn,
            tail: hasTail,
            textStyle: TextStyle(
                color: isOwn ? Colors.black : Colors.white, fontSize: 16),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              'Sent at ${message.sendTime}',
              style: const TextStyle(color: Colors.black38, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
