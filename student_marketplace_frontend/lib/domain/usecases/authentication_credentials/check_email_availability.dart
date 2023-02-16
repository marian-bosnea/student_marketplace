import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/user/authentication_credentials_repository.dart';

class CheckEmailAvailability implements Usecase<bool, String> {
  final AuthenticationCredentialsRepository repository;

  CheckEmailAvailability({required this.repository});

  @override
  Future<Either<Failure, bool>> call(String email) async =>
      await repository.checkEmailAvailability(email);
}
