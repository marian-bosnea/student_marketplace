import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import '../../repositories/user_services.dart';

import '../../../../core/error/failures.dart';

class IsSignedInUsecase implements Usecase<bool, NoParams> {
  final UserServices repository;

  IsSignedInUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams n) {
    return repository.isSignedIn();
  }
}
