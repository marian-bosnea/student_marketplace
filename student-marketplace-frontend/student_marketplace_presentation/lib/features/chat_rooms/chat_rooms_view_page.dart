import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';

import 'package:student_marketplace_presentation/features/chat_rooms/chat_rooms_view_bloc.dart';
import 'package:student_marketplace_presentation/features/chat_rooms/chat_rooms_view_state.dart';
import 'package:student_marketplace_presentation/features/shared/empty_list_placeholder.dart';

import '../../core/config/on_generate_route.dart';

class ChatRoomsViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomsViewBloc, ChatRoomsViewState>(
        builder: (context, state) {
      return state.rooms.isEmpty
          ? const EmptyListPlaceholder(
              message: "You don't have any active conversations")
          : Material(
              child: ListView.builder(
                  itemCount: state.rooms.length,
                  itemBuilder: (context, index) => SizedBox(
                        width: ScreenUtil().setHeight(200),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              PageNames.messagesPage,
                              arguments: state.rooms.elementAt(index)),
                          child: ChatRoomItem(
                            room: state.rooms.elementAt(index),
                          ),
                        ),
                      )),
            );
    });
  }
}

class ChatRoomItem extends StatelessWidget {
  final ChatRoomEntity room;
  const ChatRoomItem({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: CircleAvatar(
                foregroundImage: Image.memory(
              room.partnerAvatar,
            ).image),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 60,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                room.partnerName,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              Text(
                room.lastMessage,
              ),
              SizedBox(
                height: 5,
              ),
              Divider()
            ]),
          ),
        ],
      ),
    );
  }
}
