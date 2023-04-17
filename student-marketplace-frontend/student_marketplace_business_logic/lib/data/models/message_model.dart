import 'package:student_marketplace_business_logic/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel(
      {super.senderId,
      super.senderName,
      required super.content,
      required super.sendTime});

  static MessageModel fromJson(Map<String, dynamic> json) {
    int id;
    if (json['sender_id'] is int) {
      id = json['sender_id'];
    } else {
      id = int.parse(json['sender_id']);
    }
    return MessageModel(
        content: json['content'],
        sendTime: json['time'],
        senderId: id,
        senderName: json['sender_name']);
  }
}
