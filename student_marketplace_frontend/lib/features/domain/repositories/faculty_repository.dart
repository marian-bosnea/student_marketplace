import 'package:dartz/dartz.dart';
import '../entities/faculty_entity.dart';

import '../../../core/error/failures.dart';
import '../entities/sale_post_entity.dart';

abstract class FacultyRepository {
  Future<Either<Failure, List<FacultyEntity>>> getAllFaculties();
}
