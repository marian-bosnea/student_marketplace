import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  int? senderId;
  final String? senderName;
  final String content;
  final String sendTime;

  MessageEntity(
      {this.senderId,
      this.senderName,
      required this.content,
      required this.sendTime});

  @override
  List<Object?> get props => [senderId, senderName, content, sendTime];
}
