import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_services.dart';
import '../data_sources/contracts/user_services_local_data_source.dart';
import '../data_sources/contracts/user_services_remote_data_source.dart';

class UserServicesImpl implements UserServices {
  final UserServicesRemoteDataSource remoteDataSource;
  final UserServicesLocalDataSource localDataSource;

  const UserServicesImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, bool>> isSignedIn(UserEntity user) async =>
      remoteDataSource.isSignedIn(user);

  @override
  Future<Either<Failure, String>> signInUser(UserEntity user) async =>
      remoteDataSource.signInUser(user);
  @override
  Future<Either<Failure, bool>> signOutUser(UserEntity user) async =>
      remoteDataSource.signOutUser(user);

  @override
  Future<Either<Failure, bool>> signUpUser(UserEntity user) async =>
      remoteDataSource.signUpUser(user);

  @override
  Future<Either<Failure, String>> getAuthorizationToken() async =>
      localDataSource.getAuthorizationToken();

  @override
  Future<Either<Failure, bool>> checkIfEmailIsAvailable(
          UserEntity user) async =>
      remoteDataSource.checkIfEmailIsAvailable(user);
}
