import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';
import 'package:student_marketplace_presentation/features/messages/messages_view_bloc.dart';
import 'package:student_marketplace_presentation/features/messages/widgets/message_item.dart';

import '../../core/config/injection_container.dart';
import 'messages_view_state.dart';

class MessagesViewPage extends StatelessWidget {
  final ChatRoomEntity room;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  MessagesViewPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagesViewBloc()..init(room),
      child: BlocConsumer<MessagesViewBloc, MessagesViewState>(
        listener: (context, state) {
          if (state.status == MessagesViewStatus.loaded) {
            final bloc = BlocProvider.of<MessagesViewBloc>(context);
            if (!bloc.isClosed) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent + 20);
              });
            }
          }
        },
        builder: (context, state) {
          return PlatformScaffold(
            cupertino: (context, platform) =>
                CupertinoPageScaffoldData(resizeToAvoidBottomInset: true),
            appBar: PlatformAppBar(
              backgroundColor: Theme.of(context).highlightColor,
              title: Text(
                room.partnerName,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              trailingActions: [
                if (state.room != null)
                  CircleAvatar(
                      foregroundImage: Image.memory(
                    state.room!.partnerAvatar,
                  ).image),
              ],
              cupertino: (context, platform) => CupertinoNavigationBarData(
                  automaticallyImplyLeading: true,
                  previousPageTitle: 'Messages'),
            ),
            body: Material(
              color: Theme.of(context).primaryColor,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height - 100,
                              child: _getBodyWidget(context, state)),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 80,
                            height: 40,
                            child: PlatformTextField(
                                controller: _textController,
                                cupertino: (context, platform) =>
                                    CupertinoTextFieldData(
                                        placeholderStyle: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .highlightColor))),
                                hintText: 'Message',
                                onSubmitted: (text) =>
                                    _onSubmited(context, text)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                color: Theme.of(context).splashColor),
                            width: 45,
                            height: 45,
                            child: PlatformIconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () =>
                                  _onSubmited(context, _textController.text),
                              icon: const Center(
                                child: Icon(
                                  FontAwesomeIcons.solidPaperPlane,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
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
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 30),
          child: ListView.builder(
              controller: _scrollController,
              reverse: false,
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                bool hasTail = false;

                if (index != state.messages.length - 1) {
                  hasTail = state.messages.elementAt(index).senderId !=
                      state.messages.elementAt(index + 1).senderId;
                }

                if (index == state.messages.length - 1) {
                  hasTail = true;
                }

                return MessageItem(
                    hasTail: hasTail,
                    message: state.messages.elementAt(index),
                    isOwn: !(state.messages.elementAt(index).senderId ==
                        room.partnerId));
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

  _onSubmited(BuildContext context, String text) async {
    if (text.trim().isEmpty) return;
    _textController.text = '';

    await BlocProvider.of<MessagesViewBloc>(context).sendMessage(text);

    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose(BuildContext context) {
    sl.get<MessagesViewBloc>().close();
  }
}
