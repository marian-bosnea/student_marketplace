import 'package:student_marketplace_frontend/features/data/data_sources/contracts/auth_session_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/domain/entities/auth_session_entity.dart';
import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/auth_repository.dart';

import '../data_sources/contracts/auth_session_local_data_source.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthSessionRemoteDataSource remoteDataSource;
  final AuthSessionLocalDataSource localDataSource;

  AuthRepositoryImpl(
      {required this.localDataSource, required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthSessionEntity>> authenticate(
      {required String email, required String password}) async {
    return await remoteDataSource.authenticate(
        email: email, password: password);
  }

  @override
  Future<Either<Failure, AuthSessionEntity>> getCachedSession() async {
    return await localDataSource.getCachedToken();
  }
}
