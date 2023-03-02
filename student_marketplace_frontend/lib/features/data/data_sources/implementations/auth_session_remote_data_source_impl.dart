import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/auth_session_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/data/models/auth_session_model.dart';
import 'package:student_marketplace_frontend/features/domain/entities/auth_session_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/http_interface.dart';

class AuthSessionRemoteDataSourceImpl extends AuthSessionRemoteDataSource {
  final HttpInterface http = HttpInterface();

  @override
  Future<Either<Failure, AuthSessionEntity>> authenticate(
      {required String email, required String password}) async {
    final HttpInterface http = HttpInterface();
    try {
      final result = await http.signInUser(email, password);
      return Right(AuthSessionModel(token: result));
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deauthenticate(
      AuthSessionEntity session) async {
    try {
      final result = await http.logOutUser(session.token);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getAuthenticationStatus(
      AuthSessionEntity session) async {
    try {
      final result = await http.isUserLoggedIn(session.token);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }
}
