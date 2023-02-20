import '../../../domain/entities/sale_post_entity.dart';

import '../../../../core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../contracts/sale_post_remote_data_source.dart';

class SalePostRemotedataSourceImpl implements SalePostRemoteDataSource {
  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPosts() {
    // TODO: implement getAllPosts
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
      String categoryId) {
    // TODO: implement getAllPostsByCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
      String ownerId) {
    // TODO: implement getAllPostsByOwner
    throw UnimplementedError();
  }
}
