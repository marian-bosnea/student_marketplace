import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/message_entity.dart';

abstract class MessageRemoteDataSource {
  Future<Either<Failure, List<MessageEntity>>> getByRoom(
      String token, int partnerId);

  Future<Either<Failure, bool>> sendMessage(
      String token, int roomId, String content);

  Future<Either<Failure, void>> onMessageReceived(
      String token, Function(MessageEntity) callback);
}
