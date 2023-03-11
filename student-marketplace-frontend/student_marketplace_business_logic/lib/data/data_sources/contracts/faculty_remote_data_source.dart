import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/faculty_entity.dart';

abstract class FacultyRemoteDataSource {
  Future<Either<Failure, List<FacultyEntity>>> getAllFaculties();
}
