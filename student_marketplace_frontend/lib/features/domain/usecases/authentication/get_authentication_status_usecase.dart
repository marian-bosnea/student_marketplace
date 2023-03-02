import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/domain/operations/auth_session_operations.dart';

import '../../../../core/usecases/usecase.dart';

class GetAuthenticationStatusUsecase extends Usecase<bool, AuthSessionParam> {
  final AuthSessionOperations operations;
  GetAuthenticationStatusUsecase({required this.operations});

  @override
  Future<Either<Failure, bool>> call(AuthSessionParam params) async =>
      operations.getAuthenticationStatus(params.session);
}
