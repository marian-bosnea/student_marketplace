import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

import '../../../core/error/failures.dart';

abstract class UserServices {
  Future<Either<Failure, String>> getAuthorizationToken();

  Future<Either<Failure, String>> signInUser(UserEntity user);
  Future<Either<Failure, bool>> signUpUser(UserEntity user);

  Future<Either<Failure, bool>> signOutUser(UserEntity user);

  Future<Either<Failure, bool>> isSignedIn(UserEntity user);
}
