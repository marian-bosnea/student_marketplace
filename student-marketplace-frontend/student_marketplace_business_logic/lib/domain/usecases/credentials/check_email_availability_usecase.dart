import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../operations/credentials_operations.dart';

class CheckEmailAvailabilityUsecase extends Usecase<bool, CredentialsParams> {
  final CredentialsOperations operations;

  CheckEmailAvailabilityUsecase({required this.operations});

  @override
  Future<Either<Failure, bool>> call(CredentialsParams params) async =>
      operations.checkIfEmailIsAvailable(params.credentials);
}
