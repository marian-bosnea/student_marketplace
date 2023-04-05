import 'package:mockito/annotations.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/get_cached_session_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/product_category/get_all_categories_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/add_to_favorites_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_by_category_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_by_query_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_detailed_post_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/remove_from_favorites_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/get_user_usecase.dart';

@GenerateMocks([
  GetUserProfileUsecase,
  GetAllPostsUsecase,
  GetAllPostsByCategoryUsecase,
  GetAllCategoriesUsecase,
  GetCachedSessionUsecase,
  GetDetailedPostUsecase,
  AddToFavoritesUsecase,
  GetAllPostsByQueryUsecase,
  RemoveFromFavoritesUsecase,
])
void main() {}
