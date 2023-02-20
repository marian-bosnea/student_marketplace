import '../data_sources/contracts/sale_post_remote_data_source.dart';
import '../../domain/entities/sale_post_entity.dart';
import '../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/sale_post_repository.dart';

class SalePostRepositoryImpl implements SalePostRepository {
  final SalePostRemoteDataSource remoteDataSource;

  SalePostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPosts() async =>
      remoteDataSource.getAllPosts();

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
          String categoryId) async =>
      remoteDataSource.getAllPostsByCategory(categoryId);

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
          String ownerId) async =>
      remoteDataSource.getAllPostsByOwner(ownerId);
}
