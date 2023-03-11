import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/auth_session_entity.dart';
import '../../repositories/auth_session_repository.dart';

class GetCachedSessionUsecase extends Usecase<AuthSessionEntity, NoParams> {
  final AuthSessionRepository repository;
  GetCachedSessionUsecase({required this.repository});

  @override
  Future<Either<Failure, AuthSessionEntity>> call(NoParams params) async {
    return repository.getCachedSession();
  }
}
