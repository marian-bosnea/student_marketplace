import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/domain/operations/auth_session_operations.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/auth_session_repository.dart';

class DeauthenticateUsecase extends Usecase<bool, NoParams> {
  final AuthSessionOperations authSessionOperations;
  final AuthSessionRepository authSessionRepository;

  DeauthenticateUsecase(
      {required this.authSessionOperations,
      required this.authSessionRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    final session = await authSessionRepository.getCachedSession();
    if (session is Left) return Left(UnauthenticatedFailure());

    final token = (session as Right).value;
    final result = await authSessionOperations.deauthenticate(token);

    if (result is Left) return Left(NetworkFailure());

    return result;
  }
}
