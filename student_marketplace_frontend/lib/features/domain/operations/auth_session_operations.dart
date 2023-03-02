import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/domain/entities/auth_session_entity.dart';

import '../../../core/error/failures.dart';

abstract class AuthSessionOperations {
  Future<Either<Failure, bool>> deauthenticate(AuthSessionEntity session);

  Future<Either<Failure, bool>> getAuthenticationStatus(
      AuthSessionEntity session);
}
