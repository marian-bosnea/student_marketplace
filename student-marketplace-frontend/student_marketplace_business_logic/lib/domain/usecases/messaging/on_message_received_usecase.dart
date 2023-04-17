import 'package:student_marketplace_business_logic/core/error/failures.dart';

import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/repositories/auth_session_repository.dart';
import 'package:student_marketplace_business_logic/domain/repositories/message_repository.dart';

import '../../../core/usecase/usecase.dart';

class OnMessageReceivedUsecase extends Usecase<void, MessageCallbackParam> {
  final AuthSessionRepository authRepository;
  final MessageRepository messageRepository;
  OnMessageReceivedUsecase(
      {required this.authRepository, required this.messageRepository});

  @override
  Future<Either<Failure, void>> call(MessageCallbackParam params) async {
    final session = await authRepository.getCachedSession();
    if (session is Left) return Left(UnauthenticatedFailure());

    final token = (session as Right).value;

    return messageRepository.onMessageReceived(token.token, params.callback);
  }
}
