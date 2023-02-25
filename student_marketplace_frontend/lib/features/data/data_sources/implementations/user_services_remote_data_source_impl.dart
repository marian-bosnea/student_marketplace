import '../../../../core/error/failures.dart';
import '../../../../core/services/http_interface.dart';
import '../contracts/user_services_remote_data_source.dart';
import '../../../domain/entities/user_entity.dart';

import 'package:dartz/dartz.dart';

class UserServicesRemoteDataSourceImpl implements UserServicesRemoteDataSource {
  final HttpInterface http = HttpInterface();

  @override
  Future<Either<Failure, bool>> isSignedIn(UserEntity entity) async {
    try {
      if (entity.authToken == null) {
        return Left(NetworkFailure());
      } else {
        final result = await http.isUserLoggedIn(entity.authToken!);
        return Right(result);
      }
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> signInUser(UserEntity user) async {
    try {
      final result = await http.signInUser(user.email!, user.password!);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> signOutUser(UserEntity userEntity) async {
    try {
      if (userEntity.authToken == null) {
        return Left(NetworkFailure());
      } else {
        final result = await http.logOutUser(userEntity.authToken!);
        return Right(result);
      }
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> signUpUser(UserEntity user) async {
    try {
      final result = await http.registerUser(user);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkIfEmailIsAvailable(UserEntity user) async {
    try {
      final result = await http.checkUserEmail(user.email!);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }
}
