import 'package:student_marketplace_business_logic/data/data_sources/contracts/address_remote_data_source.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';
import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/repositories/address_repository.dart';

class AddressRepositoryImpl extends AddressRepository {
  final AddressRemoteDataSource remoteDataSource;
  AddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AddressEntity>>> read(String token) =>
      remoteDataSource.read(token);
}
