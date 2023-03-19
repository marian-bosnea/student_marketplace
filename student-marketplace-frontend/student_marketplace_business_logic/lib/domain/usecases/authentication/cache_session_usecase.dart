import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../operations/auth_session_operations.dart';

class CacheSessionUsecase extends Usecase<void, AuthSessionParam> {
  final AuthSessionOperations operations;

  CacheSessionUsecase({
    required this.operations,
  });

  @override
  Future<Either<Failure, void>> call(AuthSessionParam params) async =>
      operations.cacheSession(params.session);
}
