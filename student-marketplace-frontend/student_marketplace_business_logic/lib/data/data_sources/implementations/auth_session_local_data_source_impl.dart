import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/auth_session_entity.dart';
import '../../models/auth_session_model.dart';
import '../contracts/auth_session_local_data_source.dart';

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
