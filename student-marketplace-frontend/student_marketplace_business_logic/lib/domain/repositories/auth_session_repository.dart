import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/auth_session_entity.dart';

abstract class AuthSessionRepository {
  Future<Either<Failure, AuthSessionEntity>> authenticate(
      {required String email, required String password});

  Future<Either<Failure, AuthSessionEntity>> getCachedSession();
}
