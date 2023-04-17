import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ChatRoomEntity extends Equatable {
  final int id;
  final int partnerId;
  final String partnerName;
  final Uint8List partnerAvatar;
  final String lastMessage;
  final String lastMessageTime;

  ChatRoomEntity(
      {required this.id,
      required this.partnerId,
      required this.partnerName,
      required this.partnerAvatar,
      required this.lastMessage,
      required this.lastMessageTime});

  @override
  List<Object?> get props =>
      [id, partnerId, partnerName, partnerAvatar, lastMessage, lastMessageTime];
}
