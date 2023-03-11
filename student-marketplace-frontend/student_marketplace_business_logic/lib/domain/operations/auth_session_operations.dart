import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/auth_session_entity.dart';

abstract class AuthSessionOperations {
  Future<Either<Failure, bool>> deauthenticate(AuthSessionEntity session);

  Future<Either<Failure, bool>> getAuthenticationStatus(
      AuthSessionEntity session);
}
