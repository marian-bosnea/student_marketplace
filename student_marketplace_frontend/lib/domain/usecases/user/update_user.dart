import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/domain/repositories/user_repostory.dart';

import '../../../core/error/failures.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser({required this.repository});

  Future<Either<Failure, bool>> call() async => repository.updateUser();
}
