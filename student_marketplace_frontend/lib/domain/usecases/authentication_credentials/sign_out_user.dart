import 'package:dartz/dartz.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/user/authentication_credentials_repository.dart';

import '../../../core/error/failures.dart';

class SignOutUser implements Usecase<bool, String> {
  final AuthenticationCredentialsRepository repository;

  SignOutUser({required this.repository});

  @override
  Future<Either<Failure, bool>> call(String token) async =>
      repository.signOutUser(token);
}
