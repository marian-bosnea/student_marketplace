import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';

abstract class MessageOperations {
  Future<Either<Failure, bool>> sendMessage(
      String token, int roomId, String content);
}
