import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../operations/auth_session_operations.dart';

class GetAuthenticationStatusUsecase extends Usecase<bool, AuthSessionParam> {
  final AuthSessionOperations operations;
  GetAuthenticationStatusUsecase({required this.operations});

  @override
  Future<Either<Failure, bool>> call(AuthSessionParam params) async =>
      operations.getAuthenticationStatus(params.session);
}
