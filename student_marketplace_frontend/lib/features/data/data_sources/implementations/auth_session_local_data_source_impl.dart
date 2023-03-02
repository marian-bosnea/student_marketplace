import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/auth_session_local_data_source.dart';
import 'package:student_marketplace_frontend/features/data/models/auth_session_model.dart';
import 'package:student_marketplace_frontend/features/domain/entities/auth_session_entity.dart';

class AuthSessionLocalDataSourceImpl extends AuthSessionLocalDataSource {
  @override
  Future<Either<Failure, AuthSessionEntity>> getCachedToken() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs.containsKey('authorizationToken')) {
      final tokenValue = sharedPrefs.getString('authorizationToken')!;
      return Right(AuthSessionModel(token: tokenValue));
    } else {
      return Left(TokenNotFound());
    }
  }
}
