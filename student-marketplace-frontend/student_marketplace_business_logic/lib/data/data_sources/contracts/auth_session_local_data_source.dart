import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/auth_session_entity.dart';

abstract class AuthSessionLocalDataSource {
  Future<Either<Failure, AuthSessionEntity>> getCachedToken();
}
