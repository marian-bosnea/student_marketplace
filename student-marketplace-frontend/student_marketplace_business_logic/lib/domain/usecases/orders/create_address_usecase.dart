import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/operations/address_operations.dart';

import '../../repositories/auth_session_repository.dart';

class CreateAddressUsecase extends Usecase<bool, AddressParam> {
  final AuthSessionRepository authRepository;
  final AddressOperations addressOperations;

  CreateAddressUsecase(
      {required this.authRepository, required this.addressOperations});

  @override
  Future<Either<Failure, bool>> call(AddressParam params) async {
    final session = await authRepository.getCachedSession();
    if (session is Left) return Left(UnauthenticatedFailure());

    final token = (session as Right).value;

    final result = await addressOperations.create(token.token, params.address);
    if (result is Left) return Left(NetworkFailure());

    return result;
  }
}
