import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';

abstract class AuthenticationCredentialsRepository {
  Future<Either<Failure, bool>> checkEmailAvailability(String email);
  Future<Either<Failure, bool>> isEmailAssociatedWithAnAccount(String email);

  Future<Either<Failure, String>> signInUser(String email, String password);
  Future<Either<Failure, bool>> signOutUser(String token);
}
