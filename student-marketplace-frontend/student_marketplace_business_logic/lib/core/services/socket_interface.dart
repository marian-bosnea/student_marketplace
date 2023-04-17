import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:student_marketplace_business_logic/data/models/message_model.dart';
import 'package:student_marketplace_business_logic/domain/entities/message_entity.dart';

class SocketInterface {
  final String token;

  late io.Socket socket;
  late Completer<List<MessageEntity>> completer;
  static SocketInterface? _instance;

  static SocketInterface getInstance(String token) {
    if (_instance == null) {
      _instance = SocketInterface._(token);
    }
    return _instance!;
  }

  SocketInterface._(this.token) {
    final queryParams = {
      'token': token,
    };

    socket = io.io('http://192.168.0.101:3000', <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
      'query': queryParams
    });

    socket.on('connect', (_) {
      print('Connected to server via socket');
    });

    socket.connect();
  }

  void joinRoom(int partnerId) {
    socket.emit('join-room', {'partnerId': partnerId});
  }

  void sendMessage(int roomId, String content) {
    final json = {"roomId": roomId, "content": content};

    socket.emit('send-message', json);
  }

  void listenToNewMessages(Function(MessageEntity) callback) {
    socket.on('receive-message', (data) async {
      callback(MessageModel.fromJson(data));
    });
  }

  Future<List<MessageEntity>> fetchPastMessages() {
    Completer<List<MessageEntity>> completer = Completer<List<MessageEntity>>();

    socket.on('prev-messages', (data) {
      List<MessageEntity> messages = [];
      for (var json in data) {
        messages.add(MessageModel.fromJson(json));
      }
      if (!completer.isCompleted) completer.complete(messages);
    });

    // Handle error case
    socket.on('error', (error) {
      completer.completeError('Error fetching past messages');
    });

    return completer.future;
  }
}
