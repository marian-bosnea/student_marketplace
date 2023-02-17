import 'package:student_marketplace_frontend/features/data/data_sources/contracts/user_services_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/domain/entities/user_entity.dart';
import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/user_services.dart';

class UserServiceImpl implements UserServices {
  final UserServicesRemoteDataSource remoteDataSource;

  const UserServiceImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> isSignedIn() async =>
      remoteDataSource.isSignedIn();

  @override
  Future<Either<Failure, bool>> signInUser(UserEntity user) async =>
      remoteDataSource.signInUser(user);
  @override
  Future<Either<Failure, bool>> signOutUser(UserEntity user) async =>
      remoteDataSource.signOutUser(user);

  @override
  Future<Either<Failure, bool>> signUpUser(UserEntity user) async =>
      remoteDataSource.signUpUser(user);
}
