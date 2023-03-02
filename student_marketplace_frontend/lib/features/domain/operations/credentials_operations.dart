import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/domain/entities/credentials_entity.dart';

import '../../../core/error/failures.dart';

abstract class CredentialsOperations {
  Future<Either<Failure, bool>> checkIfEmailIsAvailable(
      CredentialsEntity credentials);
}
