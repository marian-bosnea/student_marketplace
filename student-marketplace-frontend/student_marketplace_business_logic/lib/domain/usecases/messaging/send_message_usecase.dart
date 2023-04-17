import 'package:student_marketplace_business_logic/core/error/failures.dart';

import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/operations/message_operations.dart';

import '../../../core/usecase/usecase.dart';
import '../../repositories/auth_session_repository.dart';

class SendMessageUsecase extends Usecase<bool, MessageParam> {
  final MessageOperations messageOperations;
  final AuthSessionRepository authRepository;

  SendMessageUsecase(
      {required this.authRepository, required this.messageOperations});

  @override
  Future<Either<Failure, bool>> call(MessageParam params) async {
    final result = await authRepository.getCachedSession();
    if (result is Left) return Left(UnauthenticatedFailure());

    final session = (result as Right).value;

    final res = await messageOperations.sendMessage(
        session.token, params.roomId, params.content);

    return res;
  }
}
