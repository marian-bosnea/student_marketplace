import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';

class ChatRoomModel extends ChatRoomEntity {
  ChatRoomModel(
      {required super.id,
      required super.partnerId,
      required super.partnerName,
      required super.partnerAvatar,
      required super.lastMessage,
      required super.lastMessageTime});

  // static RoomModel fromJson(Map<String, dynamic> json) => RoomModel(
  //     id: json['id'] as int,
  //     partnerId: json['partner_id'] as int,
  //     partnerName: json['partner_name'] as String,
  //     lastMessage: json['last_message'] as String,
  //     lastMessageTime: json['last_message_time'] as String);
}
