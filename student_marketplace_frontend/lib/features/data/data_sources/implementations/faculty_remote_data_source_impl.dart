import '../../../domain/entities/faculty_entity.dart';

import '../../../../core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../contracts/faculty_remote_data_source.dart';

class FacultyRemoteDataSourceImpl implements FacultyRemoteDataSource {
  @override
  Future<Either<Failure, List<FacultyEntity>>> getAllFaculties() async {
    return Left(NetworkFailure());
  }
}
