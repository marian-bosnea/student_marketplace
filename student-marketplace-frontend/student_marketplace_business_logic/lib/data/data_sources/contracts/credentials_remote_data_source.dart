import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/credentials_entity.dart';

abstract class CredentialsRemoteDataSource {
  Future<Either<Failure, bool>> checkIfEmailIsAvailable(
      CredentialsEntity credentials);
}
