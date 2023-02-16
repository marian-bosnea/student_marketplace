import 'package:dartz/dartz.dart';
import '../../repositories/authentication_credentials_repository.dart';

import '../../../core/error/failures.dart';

class SignOutUser {
  final AuthenticationCredentialsRepository repository;

  SignOutUser({required this.repository});

  Future<Either<Failure, bool>> call({required token}) async =>
      repository.signOutUser(token);
}
