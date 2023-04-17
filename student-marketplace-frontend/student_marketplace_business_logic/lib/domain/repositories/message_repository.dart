import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/entities/message_entity.dart';

import '../../core/error/failures.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<MessageEntity>>> getByRoom(
      String token, int partnerId);

  Future<Either<Failure, void>> onMessageReceived(
      String token, Function(MessageEntity) callback);
}
