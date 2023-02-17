import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/user_services_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/domain/entities/user_entity.dart';

class UserServicesRemoteDataSourceImpl implements UserServicesRemoteDataSource {
  @override
  Future<Either<Failure, bool>> isSignedIn() {
    // TODO: implement isSignedIn
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> signInUser(UserEntity user) {
    // TODO: implement signInUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> signOutUser(UserEntity user) {
    // TODO: implement signOutUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> signUpUser(UserEntity user) {
    // TODO: implement signUpUser
    throw UnimplementedError();
  }
}
