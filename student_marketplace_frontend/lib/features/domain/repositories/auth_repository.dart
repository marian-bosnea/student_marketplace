import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/domain/entities/auth_session_entity.dart';

import '../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSessionEntity>> authenticate(
      {required String email, required String password});

  Future<Either<Failure, AuthSessionEntity>> getCachedSession();
}
