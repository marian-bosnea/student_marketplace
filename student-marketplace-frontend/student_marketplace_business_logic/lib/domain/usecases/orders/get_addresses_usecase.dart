import 'package:http/http.dart';
import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';

import '../../repositories/address_repository.dart';
import '../../repositories/auth_session_repository.dart';
import '../../entities/address_entity.dart';

class GetAddressesUsecase extends Usecase<List<AddressEntity>, NoParams> {
  final AuthSessionRepository authRepository;
  final AddressRepository addressRepository;

  GetAddressesUsecase(
      {required this.authRepository, required this.addressRepository});

  @override
  Future<Either<Failure, List<AddressEntity>>> call(NoParams params) async {
    final session = await authRepository.getCachedSession();
    if (session is Left) return Left(UnauthenticatedFailure());

    final token = (session as Right).value;

    final result = await addressRepository.read(token.token);
    if (result is Left) return Left(NetworkFailure());

    return result;
  }
}
