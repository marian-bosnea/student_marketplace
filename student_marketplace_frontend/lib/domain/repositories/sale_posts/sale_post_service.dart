import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/sale_posts/sale_object_post.dart';
import '../../entities/user/user.dart';

abstract class SalePostService {
  Future<Either<Failure, List<SalePost>>> getAllPosts();
  Future<Either<Failure, List<SalePost>>> getPostsByCategory(String category);
  Future<Either<Failure, List<SalePost>>> getUsersPost(User user);
}
