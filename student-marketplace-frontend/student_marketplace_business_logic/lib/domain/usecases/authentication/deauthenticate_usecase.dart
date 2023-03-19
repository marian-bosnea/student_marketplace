import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../operations/auth_session_operations.dart';
import '../../repositories/auth_session_repository.dart';

class DeauthenticateUsecase extends Usecase<bool, NoParams> {
  final AuthSessionOperations authSessionOperations;
  final AuthSessionRepository authSessionRepository;

  DeauthenticateUsecase(
      {required this.authSessionOperations,
      required this.authSessionRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    final resultSession = await authSessionRepository.getCachedSession();
    if (resultSession is Left) return Left(UnauthenticatedFailure());

    final session = (resultSession as Right).value;
    final result = await authSessionOperations.deauthenticate(session);
    if (result is Left) return Left(NetworkFailure());
    return result;
  }
}
