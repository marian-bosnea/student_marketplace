import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

import '../../../core/error/failures.dart';

abstract class UserServices {
  Future<Either<Failure, bool>> checkIfEmailIsAvailable(UserEntity user);

  Future<Either<Failure, bool>> signUpUser(UserEntity user);

  Future<Either<Failure, bool>> signOutUser(UserEntity user);

  Future<Either<Failure, bool>> isSignedIn(UserEntity user);
}
