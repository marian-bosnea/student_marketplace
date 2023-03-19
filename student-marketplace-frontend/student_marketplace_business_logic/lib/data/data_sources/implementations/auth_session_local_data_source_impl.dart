import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/auth_session_entity.dart';
import '../../models/auth_session_model.dart';
import '../contracts/auth_session_local_data_source.dart';

class AuthSessionLocalDataSourceImpl extends AuthSessionLocalDataSource {
  final tokenKey = 'authorizationToken';
  final keepSignedKey = 'keepSignedIn';

  @override
  Future<Either<Failure, AuthSessionEntity>> getCachedSession() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs.containsKey(tokenKey) &&
        sharedPrefs.containsKey(keepSignedKey)) {
      final tokenValue = sharedPrefs.getString(tokenKey)!;
      final keepSignedIn = sharedPrefs.getBool(keepSignedKey);

      return Right(
          AuthSessionModel(token: tokenValue, keepPerssistent: keepSignedIn!));
    } else {
      return Left(TokenNotFound());
    }
  }

  @override
  Future<Either<Failure, void>> cacheSession(AuthSessionEntity session) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final keepPerssistent = session.keepPerssistent;
    sharedPrefs.setBool(keepSignedKey, keepPerssistent);
    sharedPrefs.setString(tokenKey, session.token);

    void a;
    return Right(a);
  }
}
