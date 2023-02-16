import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/user/authentication_credentials_repository.dart';

import '../../../core/error/failures.dart';

class SignInUser implements Usecase<String, NoParams> {
  final AuthenticationCredentialsRepository repository;

  SignInUser({required this.repository});

  @override
  Future<Either<Failure, String>> call(NoParams n) async =>
      await repository.signInUser();
}
