import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/user_entity.dart';

abstract class UserServicesRemoteDataSource {
  Future<Either<Failure, String>> signInUser(UserEntity user);
  Future<Either<Failure, bool>> signUpUser(UserEntity user);

  Future<Either<Failure, bool>> signOutUser(UserEntity user);

  Future<Either<Failure, bool>> isSignedIn(UserEntity user);
}
