import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/data/data_sources/contracts/message_remote_data_source.dart';
import 'package:student_marketplace_business_logic/domain/operations/message_operations.dart';

class MessageOperationsImpl extends MessageOperations {
  final MessageRemoteDataSource remoteDataSource;

  MessageOperationsImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> sendMessage(
          String token, int roomId, String content) =>
      remoteDataSource.sendMessage(token, roomId, content);
}
