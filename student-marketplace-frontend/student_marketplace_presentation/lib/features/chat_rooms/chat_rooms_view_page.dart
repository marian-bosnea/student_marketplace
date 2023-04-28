import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';

import 'package:student_marketplace_presentation/features/chat_rooms/chat_rooms_view_bloc.dart';
import 'package:student_marketplace_presentation/features/chat_rooms/chat_rooms_view_state.dart';
import 'package:student_marketplace_presentation/features/shared/empty_list_placeholder.dart';

import '../../core/config/on_generate_route.dart';

class ChatRoomsViewPage extends StatelessWidget {
  const ChatRoomsViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomsViewBloc, ChatRoomsViewState>(
        builder: (context, state) {
      return state.rooms.isEmpty
          ? const EmptyListPlaceholder(
              message: "You don't have any active conversations")
          : Material(
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                  itemCount: state.rooms.length,
                  itemBuilder: (context, index) =>
                      state.rooms.elementAt(index).lastMessage.isEmpty
                          ? Container()
                          : SizedBox(
                              width: ScreenUtil().setHeight(200),
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    RouteNames.messages,
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
      height: 90,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  child: CircleAvatar(
                      foregroundImage: Image.memory(
                    room.partnerAvatar,
                  ).image),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.partnerName,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          room.lastMessage,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ]),
                ),
                SizedBox(
                  width: 20,
                  child: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).textTheme.displayMedium!.color,
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.2,
            indent: 60,
            color: Theme.of(context).dividerColor,
          )
        ],
      ),
    );
  }
}
