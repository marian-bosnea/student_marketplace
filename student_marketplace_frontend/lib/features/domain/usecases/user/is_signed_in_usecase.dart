import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/user_services.dart';

import '../../../../core/error/failures.dart';

class IsSignedInUsecase implements Usecase<bool, UserParam> {
  final UserServices repository;

  IsSignedInUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(UserParam n) {
    return repository.isSignedIn(n.user);
  }
}
