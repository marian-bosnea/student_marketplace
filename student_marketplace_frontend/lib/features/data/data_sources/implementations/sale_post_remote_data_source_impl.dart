import 'package:student_marketplace_frontend/core/services/http_interface.dart';

import '../../../domain/entities/sale_post_entity.dart';

import '../../../../core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../contracts/sale_post_remote_data_source.dart';

class SalePostRemotedataSourceImpl implements SalePostRemoteDataSource {
  HttpInterface httpInterface = HttpInterface();

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPosts(
      String token) async {
    final result = await httpInterface.fetchAllSalePosts(token);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
      String token, String categoryId) {
    // TODO: implement getAllPostsByCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
      String token, String ownerId) {
    // TODO: implement getAllPostsByOwner
    throw UnimplementedError();
  }
}
