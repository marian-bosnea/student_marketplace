import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/domain/entities/auth_session_entity.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/auth_repository.dart';

class GetCachedSessionUsecase extends Usecase<AuthSessionEntity, NoParams> {
  final AuthRepository repository;
  GetCachedSessionUsecase({required this.repository});

  @override
  Future<Either<Failure, AuthSessionEntity>> call(NoParams params) async {
    return repository.getCachedSession();
  }
}
