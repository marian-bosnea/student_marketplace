import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class UserServicesLocalDataSource {
  Future<Either<Failure, String>> getAuthorizationToken();
}
