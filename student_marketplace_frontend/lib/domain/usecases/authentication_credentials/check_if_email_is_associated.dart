import 'package:dartz/dartz.dart';
import '../../repositories/authentication_credentials_repository.dart';

import '../../../core/error/failures.dart';

class CheckIfEmailIsAssociated {
  final AuthenticationCredentialsRepository repository;

  CheckIfEmailIsAssociated({required this.repository});

  Future<Either<Failure, bool>> call({required String email}) async =>
      await repository.checkIfEmailIsAssociatedWithAnAccount(email);
}
