import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/operations/auth_session_operations.dart';
import '../data_sources/contracts/auth_session_remote_data_source.dart';

class AuthSessionOperationsImpl extends AuthSessionOperations {
  final AuthSessionRemoteDataSource authRemoteDataSource;
  AuthSessionOperationsImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, bool>> deauthenticate(
      AuthSessionEntity session) async {
    print('da');
    return await authRemoteDataSource.deauthenticate(session);
  }

  @override
  Future<Either<Failure, bool>> getAuthenticationStatus(
          AuthSessionEntity session) async =>
      await authRemoteDataSource.getAuthenticationStatus(session);
}
