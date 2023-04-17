import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/messaging/get_all_rooms_usecase.dart';
import 'package:student_marketplace_presentation/features/chat_rooms/chat_rooms_view_state.dart';

import '../../core/config/injection_container.dart';

class ChatRoomsViewBloc extends Cubit<ChatRoomsViewState> {
  late GetAllRoomsUsecase getAllRoomsUsecase;

  ChatRoomsViewBloc() : super(const ChatRoomsViewState()) {
    getAllRoomsUsecase = sl.call();
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
}
