import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';

abstract class AuthenticationCredentialsRepository {
  Future<Either<Failure, bool>> checkEmailAvailability(String email);
  Future<Either<Failure, bool>> checkIfEmailIsAssociatedWithAnAccount(
      String email);

  Future<Either<Failure, String>> signInUser();
  Future<Either<Failure, bool>> signOutUser(String token);
}
