import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/credentials_entity.dart';

abstract class CredentialsOperations {
  Future<Either<Failure, bool>> checkIfEmailIsAvailable(
      CredentialsEntity credentials);
}
