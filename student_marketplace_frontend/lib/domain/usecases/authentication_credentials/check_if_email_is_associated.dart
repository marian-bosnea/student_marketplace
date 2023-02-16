import 'package:dartz/dartz.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/user/authentication_credentials_repository.dart';

import '../../../core/error/failures.dart';

class CheckIfEmailIsAssociated implements Usecase<bool, String> {
  final AuthenticationCredentialsRepository repository;

  CheckIfEmailIsAssociated({required this.repository});

  @override
  Future<Either<Failure, bool>> call(String email) async =>
      await repository.checkIfEmailIsAssociatedWithAnAccount(email);
}
