import 'package:http/http.dart';
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
      String token, String categoryId) async {
    final result = await httpInterface.fetchAllSalePostsOfCategory(
        token: token, categoryId: categoryId);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
      String token, String ownerId) async {
    final result = await httpInterface.fetchAllSalePosts(token);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }

  @override
  Future<Either<Failure, bool>> update(SalePostEntity post, String token) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> upload(
      SalePostEntity post, String token) async {
    try {
      final result = await httpInterface.uploadPost(post, token);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, SalePostEntity>> getDetailedPost(
      String token, String postId) async {
    final result =
        await httpInterface.fetchDetailedSalePost(token: token, postId: postId);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }
}
