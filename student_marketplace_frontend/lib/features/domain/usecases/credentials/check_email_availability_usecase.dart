import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/domain/operations/credentials_operations.dart';

import '../../../../core/usecases/usecase.dart';

class CheckEmailAvailabilityUsecase extends Usecase<bool, CredentialsParams> {
  final CredentialsOperations operations;

  CheckEmailAvailabilityUsecase({required this.operations});

  @override
  Future<Either<Failure, bool>> call(CredentialsParams params) async =>
      operations.checkIfEmailIsAvailable(params.credentials);
}
