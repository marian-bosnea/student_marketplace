import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/message_entity.dart';
import 'package:student_marketplace_business_logic/domain/usecases/messaging/get_messages_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/messaging/on_message_received_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/messaging/send_message_usecase.dart';
import 'package:student_marketplace_presentation/features/messages/messages_view_state.dart';

import '../../core/config/injection_container.dart';

class MessagesViewBloc extends Cubit<MessagesViewState> {
  late GetMessagesUsecase getMessagesUsecase;
  late SendMessageUsecase sendMessageUsecase;
  late OnMessageReceivedUsecase onMessageReceivedUsecase;

  late bool _isClosed = false;

  MessagesViewBloc() : super(const MessagesViewState()) {
    getMessagesUsecase = sl.call();
    sendMessageUsecase = sl.call();
    onMessageReceivedUsecase = sl.call();
  }

  Future<void> init(ChatRoomEntity room) async {
    final result = await getMessagesUsecase(IdParam(id: room.partnerId));
    emit(state.copyWith(room: room, status: MessagesViewStatus.loading));

    if (result is Left) emit(state.copyWith(status: MessagesViewStatus.failed));

    final messages = (result as Right).value;

    emit(state.copyWith(messages: messages, status: MessagesViewStatus.loaded));

    onMessageReceivedUsecase(MessageCallbackParam(callback: (message) {
      var prevMessages = <MessageEntity>[];

      prevMessages.addAll(state.messages);

      prevMessages.add(message);
      if (!_isClosed) emit(state.copyWith(messages: prevMessages));
    }));
  }

  Future<void> sendMessage(String message) async {
    await sendMessageUsecase(
        MessageParam(roomId: state.room!.id, content: message));
  }

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }
}
