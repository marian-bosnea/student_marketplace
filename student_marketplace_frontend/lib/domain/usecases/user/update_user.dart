import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/domain/repositories/user/user_repostory.dart';

import '../../../core/error/failures.dart';

class UpdateUser implements Usecase<bool, NoParams> {
  final UserRepository repository;

  UpdateUser({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams n) async =>
      repository.updateUser();
}
