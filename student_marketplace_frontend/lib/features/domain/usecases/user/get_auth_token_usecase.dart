import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/user_services.dart';

class GetAuthTokenUsecase extends Usecase<String, NoParams> {
  final UserServices repository;

  GetAuthTokenUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(NoParams n) async =>
      await repository.getAuthorizationToken();
}
