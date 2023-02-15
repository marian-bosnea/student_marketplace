import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../repositories/authentication_credentials_repository.dart';

class CheckEmailAvailability {
  final AuthenticationCredentialsRepository repository;

  CheckEmailAvailability({required this.repository});

  Future<Either<Failure, bool>> call({required String email}) async =>
      await repository.checkEmailAvailability(email);
}
