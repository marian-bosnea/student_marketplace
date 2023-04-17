import 'package:student_marketplace_business_logic/data/data_sources/contracts/message_remote_data_source.dart';
import 'package:student_marketplace_business_logic/domain/entities/message_entity.dart';
import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/repositories/message_repository.dart';

class MessageRepositoryImpl extends MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MessageEntity>>> getByRoom(
          String token, int partnerId) =>
      remoteDataSource.getByRoom(token, partnerId);

  @override
  Future<Either<Failure, void>> onMessageReceived(
          String token, Function(MessageEntity) callback) =>
      remoteDataSource.onMessageReceived(token, callback);
}
