import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';
import 'package:student_marketplace_presentation/features/messages/messages_view_bloc.dart';

import 'messages_view_state.dart';

class MessagesViewPage extends StatelessWidget {
  final ChatRoomEntity room;

  const MessagesViewPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagesViewBloc()..init(room),
      child: BlocBuilder<MessagesViewBloc, MessagesViewState>(
        builder: (context, state) {
          return PlatformScaffold(
            appBar: PlatformAppBar(),
            body: Material(
              child: Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height - 70,
                      child: _getBodyWidget(context, state)),
                  SizedBox(
                    height: 70,
                    child: PlatformTextField(
                      hintText: 'Message',
                      onSubmitted: (text) =>
                          BlocProvider.of<MessagesViewBloc>(context)
                              .sendMessage(text),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context, MessagesViewState state) {
    switch (state.status) {
      case MessagesViewStatus.initial:
        return Container();

      case MessagesViewStatus.loaded:
        return Container(
          child: ListView.builder(
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages.elementAt(index);
                return PlatformText(message.content);
              }),
        );

      case MessagesViewStatus.loading:
        return Center(
          child: isMaterial(context)
              ? const CircularProgressIndicator()
              : const CupertinoActivityIndicator(),
        );

      case MessagesViewStatus.failed:
        return const Center(
          child: Text("Failed to load messages"),
        );
    }
  }
}
