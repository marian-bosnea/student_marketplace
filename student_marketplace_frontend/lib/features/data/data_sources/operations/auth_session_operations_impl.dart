import 'package:student_marketplace_frontend/features/data/data_sources/contracts/auth_session_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/domain/entities/auth_session_entity.dart';

import 'package:student_marketplace_frontend/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../domain/operations/auth_session_operations.dart';

class AuthSessionOperationsImpl extends AuthSessionOperations {
  final AuthSessionRemoteDataSource authRemoteDataSource;
  AuthSessionOperationsImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, bool>> deauthenticate(
          AuthSessionEntity session) async =>
      authRemoteDataSource.deauthenticate(session);

  @override
  Future<Either<Failure, bool>> getAuthenticationStatus(
          AuthSessionEntity session) async =>
      authRemoteDataSource.getAuthenticationStatus(session);
}
