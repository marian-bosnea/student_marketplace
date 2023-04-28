import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';
import 'package:student_marketplace_business_logic/domain/usecases/messaging/get_all_rooms_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/messaging/get_messages_usecase.dart';
import 'package:student_marketplace_presentation/features/chat_rooms/chat_rooms_view_state.dart';

import '../../core/config/injection_container.dart';

class ChatRoomsViewBloc extends Cubit<ChatRoomsViewState> {
  late GetAllRoomsUsecase getAllRoomsUsecase;
  late GetMessagesUsecase getMessagesUsecase;

  ChatRoomsViewBloc() : super(const ChatRoomsViewState()) {
    getAllRoomsUsecase = sl.call();
    getMessagesUsecase = sl.call();
  }

  Future<void> init() async {
    emit(state.copyWith(status: ChatRoomsViewStatus.loading));

    final result = await getAllRoomsUsecase(NoParams());

    if (result is Left) {
      emit(state.copyWith(status: ChatRoomsViewStatus.failed));
      return;
    }

    final rooms = (result as Right).value;

    emit(state.copyWith(rooms: rooms, status: ChatRoomsViewStatus.loaded));
  }

  Future<ChatRoomEntity?> createRoom(int partnerId) async {
    final result = await getMessagesUsecase(IdParam(id: partnerId));
    await init();

    for (final room in state.rooms) {
      if (room.partnerId == partnerId) return room;
    }

    return null;
  }
}
