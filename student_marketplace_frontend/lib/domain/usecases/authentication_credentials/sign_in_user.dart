import 'package:dartz/dartz.dart';
import '../../repositories/authentication_credentials_repository.dart';

import '../../../core/error/failures.dart';

class SignInUser {
  final AuthenticationCredentialsRepository repository;

  SignInUser({required this.repository});

  Future<Either<Failure, String>> call() async => await repository.signInUser();
}
