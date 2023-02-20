import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/user_services.dart';

class GetAuthToken extends Usecase<String, NoParams> {
  final UserServices repository;

  GetAuthToken({required this.repository});

  @override
  Future<Either<Failure, String>> call(NoParams n) async =>
      await repository.getAuthorizationToken();
}
