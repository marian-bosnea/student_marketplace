import '../../../core/services/http_interface.dart';
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
  Future<Either<Failure, bool>> addToFavorites(
      String postId, String token) async {
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
      String postId, String token) async {
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
      String postId, String token) async {
    final result =
        await httpInterface.removeFromFavorites(token: token, postId: postId);
    if (result == null) {
      return Left(NetworkFailure());
    } else {
      return Right(result);
    }
  }
}
