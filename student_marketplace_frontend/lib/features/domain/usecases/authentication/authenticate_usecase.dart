import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/domain/entities/auth_session_entity.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/auth_session_repository.dart';

class AuthenticateUsecase
    extends Usecase<AuthSessionEntity, CredentialsParams> {
  final AuthSessionRepository repository;

  AuthenticateUsecase({required this.repository});

  @override
  Future<Either<Failure, AuthSessionEntity>> call(
      CredentialsParams params) async {
    return await repository.authenticate(
        email: params.credentials.email, password: params.credentials.password);
  }
}
