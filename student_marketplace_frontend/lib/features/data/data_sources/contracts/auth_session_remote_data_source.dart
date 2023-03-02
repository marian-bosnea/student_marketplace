import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/auth_session_entity.dart';

abstract class AuthSessionRemoteDataSource {
  Future<Either<Failure, AuthSessionEntity>> authenticate(
      {required String email, required String password});
}
