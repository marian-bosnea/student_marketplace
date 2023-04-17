import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';

enum ChatRoomsViewStatus { intial, loading, loaded, failed }

class ChatRoomsViewState extends Equatable {
  final List<ChatRoomEntity> rooms;
  final ChatRoomsViewStatus status;

  const ChatRoomsViewState(
      {this.rooms = const [], this.status = ChatRoomsViewStatus.intial});

  ChatRoomsViewState copyWith(
          {List<ChatRoomEntity>? rooms, ChatRoomsViewStatus? status}) =>
      ChatRoomsViewState(
          rooms: rooms ?? this.rooms, status: status ?? this.status);

  @override
  List<Object?> get props => [rooms, status];
}
