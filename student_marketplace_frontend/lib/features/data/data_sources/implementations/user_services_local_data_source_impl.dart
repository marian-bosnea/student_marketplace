import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failures.dart';

import '../contracts/user_services_local_data_source.dart';

class UserServicesLocalDataSourceImpl implements UserServicesLocalDataSource {
  @override
  Future<Either<Failure, String>> getAuthorizationToken() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs.containsKey('authorizationToken')) {
      return Right(sharedPrefs.getString('authorizationToken')!);
    } else {
      return Left(TokenNotFound());
    }
  }
}
