import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/auth_session_entity.dart';
import '../../repositories/auth_session_repository.dart';

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
