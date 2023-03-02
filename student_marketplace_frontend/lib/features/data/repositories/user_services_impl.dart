import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_services.dart';
import '../data_sources/contracts/user_services_remote_data_source.dart';

class UserServicesImpl implements UserServices {
  final UserServicesRemoteDataSource remoteDataSource;

  const UserServicesImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> isSignedIn(UserEntity user) async =>
      remoteDataSource.isSignedIn(user);

  @override
  Future<Either<Failure, bool>> signOutUser(UserEntity user) async =>
      remoteDataSource.signOutUser(user);

  @override
  Future<Either<Failure, bool>> signUpUser(UserEntity user) async =>
      remoteDataSource.signUpUser(user);

  @override
  Future<Either<Failure, bool>> checkIfEmailIsAvailable(
          UserEntity user) async =>
      remoteDataSource.checkIfEmailIsAvailable(user);
}
