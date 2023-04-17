import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                          child: Row(
                            children: [
                              CircleAvatar(
                                  foregroundImage: Image.memory(
                                state.rooms.elementAt(index).partnerAvatar,
                              ).image),
                              Column(children: [
                                Text(
                                  state.rooms.elementAt(index).partnerName,
                                ),
                                Text(
                                  state.rooms.elementAt(index).lastMessage,
                                )
                              ]),
                            ],
                          ),
                        ),
                      )),
            );
    });
  }
}
