import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_session_repository.dart';
import '../data_sources/contracts/auth_session_local_data_source.dart';
import '../data_sources/contracts/auth_session_remote_data_source.dart';

class AuthRepositoryImpl extends AuthSessionRepository {
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
    return await localDataSource.getCachedSession();
  }
}
