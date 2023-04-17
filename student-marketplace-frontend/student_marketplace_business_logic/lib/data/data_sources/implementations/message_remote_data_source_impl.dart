import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/core/services/socket_interface.dart';
import 'package:student_marketplace_business_logic/data/data_sources/contracts/message_remote_data_source.dart';
import 'package:student_marketplace_business_logic/domain/entities/message_entity.dart';

class MessageRemoteDataSourceImpl extends MessageRemoteDataSource {
  @override
  Future<Either<Failure, List<MessageEntity>>> getByRoom(
      String token, int partnerId) async {
    final socket = SocketInterface.getInstance(token);

    socket.joinRoom(partnerId);

    final messages = await socket.fetchPastMessages();
    return Right(messages);
  }

  @override
  Future<Either<Failure, bool>> sendMessage(
      String token, int roomId, String content) async {
    final socket = SocketInterface.getInstance(token);
    socket.sendMessage(roomId, content);
    return Right(true);
  }

  @override
  Future<Either<Failure, void>> onMessageReceived(
      String token, Function(MessageEntity) callback) async {
    final socket = SocketInterface.getInstance(token);
    socket.listenToNewMessages(callback);

    void a;
    return Right(a);
  }
}
