import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/message_entity.dart';

enum MessagesViewStatus { initial, loaded, loading, failed }

class MessagesViewState extends Equatable {
  final List<MessageEntity> messages;
  final MessagesViewStatus status;

  final ChatRoomEntity? room;

  const MessagesViewState(
      {this.room,
      this.messages = const [],
      this.status = MessagesViewStatus.initial});

  MessagesViewState copyWith(
          {ChatRoomEntity? room,
          List<MessageEntity>? messages,
          MessagesViewStatus? status}) =>
      MessagesViewState(
          room: room ?? this.room,
          messages: messages ?? this.messages,
          status: status ?? this.status);

  @override
  List<Object?> get props => [messages, status, room];
}
