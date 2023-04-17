import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/entities/message_entity.dart';
import 'package:student_marketplace_business_logic/domain/repositories/auth_session_repository.dart';
import 'package:student_marketplace_business_logic/domain/repositories/message_repository.dart';

class GetMessagesUsecase extends Usecase<List<MessageEntity>, IdParam> {
  final AuthSessionRepository authRepository;
  final MessageRepository messageRepository;

  GetMessagesUsecase(
      {required this.messageRepository, required this.authRepository});

  @override
  Future<Either<Failure, List<MessageEntity>>> call(IdParam params) async {
    final session = await authRepository.getCachedSession();
    if (session is Left) return Left(UnauthenticatedFailure());

    final token = (session as Right).value;

    final result = await messageRepository.getByRoom(token.token, params.id);
    if (result is Left) return Left(NetworkFailure());

    return result;
  }
}
