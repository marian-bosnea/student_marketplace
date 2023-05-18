import '../../../core/services/http_interface.dart';
import '../../../domain/entities/sale_post_entity.dart';

import '../../../../core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../contracts/sale_post_remote_data_source.dart';

class SalePostRemotedataSourceImpl implements SalePostRemoteDataSource {
  HttpInterface httpInterface = HttpInterface();

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPosts(
      String token, int limit, int offset) async {
    final result = await httpInterface.fetchAllSalePosts(token, limit, offset);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
      {required String token,
      required int categoryId,
      required int offset,
      required int limit}) async {
    final result = await httpInterface.fetchAllSalePostsOfCategory(
        token: token, categoryId: categoryId, offset: offset, limit: limit);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
      String token, int? ownerId) async {
    final result =
        await httpInterface.fetchAllPostsByOwner(token: token, id: ownerId);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }

  @override
  Future<Either<Failure, bool>> update(
      SalePostEntity post, String token) async {
    try {
      await httpInterface.updatePost(post, token);
      return Right(true);
    } catch (_) {
      return Left(NetworkFailure());
    }
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
      String token, int postId) async {
    final result =
        await httpInterface.fetchDetailedSalePost(token: token, postId: postId);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByQuery(
      String token, String query) async {
    final result =
        await httpInterface.fetchAllPostsByQuery(token: token, query: query);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }

  @override
  Future<Either<Failure, List<SalePostEntity>>> getFavoritesPosts(
      String token) async {
    final result = await httpInterface.fetchFavoritePosts(token);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }

  @override
  Future<Either<Failure, bool>> addToFavorites(int postId, String token) async {
    final result =
        await httpInterface.addToFavorites(token: token, postId: postId);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }

  @override
  Future<Either<Failure, bool>> checkIfFavorite(
      int postId, String token) async {
    final result =
        await httpInterface.checkIfFavorite(token: token, postId: postId);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromFavorites(
      int postId, String token) async {
    final result =
        await httpInterface.removeFromFavorites(token: token, postId: postId);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }
}
