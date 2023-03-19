import 'package:get_it/get_it.dart';

import 'package:student_marketplace_business_logic/data/data_sources/contracts/auth_session_local_data_source.dart';
import 'package:student_marketplace_business_logic/data/data_sources/contracts/auth_session_remote_data_source.dart';
import 'package:student_marketplace_business_logic/data/data_sources/contracts/credentials_remote_data_source.dart';
import 'package:student_marketplace_business_logic/data/data_sources/contracts/faculty_remote_data_source.dart';
import 'package:student_marketplace_business_logic/data/data_sources/contracts/product_category_remote_data_source.dart';
import 'package:student_marketplace_business_logic/data/data_sources/contracts/sale_post_remote_data_source.dart';
import 'package:student_marketplace_business_logic/data/data_sources/contracts/user_repository_remote_data_source.dart';
import 'package:student_marketplace_business_logic/data/data_sources/contracts/user_services_remote_data_source.dart';
import 'package:student_marketplace_business_logic/data/data_sources/implementations/auth_session_local_data_source_impl.dart';
import 'package:student_marketplace_business_logic/data/data_sources/implementations/auth_session_remote_data_source_impl.dart';
import 'package:student_marketplace_business_logic/data/data_sources/implementations/credentials_remote_data_source_impl.dart';
import 'package:student_marketplace_business_logic/data/data_sources/implementations/faculty_remote_data_source_impl.dart';
import 'package:student_marketplace_business_logic/data/data_sources/implementations/product_category_remote_data_source_impl.dart';
import 'package:student_marketplace_business_logic/data/data_sources/implementations/sale_post_remote_data_source_impl.dart';
import 'package:student_marketplace_business_logic/data/data_sources/implementations/user_operations_remote_data_source_impl.dart';
import 'package:student_marketplace_business_logic/data/data_sources/implementations/user_repository_remote_data_source_impl.dart';
import 'package:student_marketplace_business_logic/data/operations/auth_session_operations_impl.dart';
import 'package:student_marketplace_business_logic/data/operations/credentials_operations_impl.dart';
import 'package:student_marketplace_business_logic/data/operations/sale_post_operations_impl.dart';
import 'package:student_marketplace_business_logic/data/operations/user_operations_impl.dart';
import 'package:student_marketplace_business_logic/data/repositories/auth_repository_impl.dart';
import 'package:student_marketplace_business_logic/data/repositories/faculty_repository_impl.dart';
import 'package:student_marketplace_business_logic/data/repositories/product_category_repistory_impl.dart';
import 'package:student_marketplace_business_logic/data/repositories/sale_post_repository_impl.dart';
import 'package:student_marketplace_business_logic/data/repositories/user_repository_impl.dart';
import 'package:student_marketplace_business_logic/domain/operations/auth_session_operations.dart';
import 'package:student_marketplace_business_logic/domain/operations/credentials_operations.dart';
import 'package:student_marketplace_business_logic/domain/operations/sale_post_operations.dart';
import 'package:student_marketplace_business_logic/domain/operations/user_operations.dart';
import 'package:student_marketplace_business_logic/domain/repositories/auth_session_repository.dart';
import 'package:student_marketplace_business_logic/domain/repositories/faculty_repository.dart';
import 'package:student_marketplace_business_logic/domain/repositories/product_category_repository.dart';
import 'package:student_marketplace_business_logic/domain/repositories/sale_post_repository.dart';
import 'package:student_marketplace_business_logic/domain/repositories/user_repository.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/authenticate_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/cache_session_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/deauthenticate_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/get_authentication_status_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/get_cached_session_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/credentials/check_email_availability_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/faculty/get_all_faculties_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/product_category/get_all_categories_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/add_to_favorites_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/check_if_favorite_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_by_category_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_by_owner_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_by_query_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_detailed_post_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_favorite_posts_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/remove_from_favorites_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/upload_post_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/get_own_user_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/sign_up_usecase.dart';

import '../../features/add_post/add_post_view_bloc.dart';
import '../../features/authentication/auth_bloc.dart';
import '../../features/detailed_post/detailed_post_view_bloc.dart';
import '../../features/favorites/favorites_view_bloc.dart';
import '../../features/home/home_view_bloc.dart';
import '../../features/login/login_view_bloc.dart';
import '../../features/posts_view/posts_view_bloc.dart';
import '../../features/register/register_view_bloc.dart';
import '../../features/search/search_view_bloc.dart';
import '../../features/user_profile/profile_view_bloc.dart';

/// Service locator
///
final sl = GetIt.instance;

Future<void> init() async {
  // Cubits

  sl.registerFactory(() => LoginViewBloc(
        signUpUsecase: sl.call(),
        authenticateUsecase: sl.call(),
        cacheSessionUsecase: sl.call(),
        checkEmailAvailabilityUsecase: sl.call(),
      ));

  sl.registerFactory(() => AuthBloc(
      authenticationStatusUsecase: sl.call(),
      deauthenticateUsecase: sl.call(),
      getCachedSessionUsecase: sl.call()));

  sl.registerFactory(() => RegisterViewBloc(
      signUpUsecase: sl.call(),
      getAllFacultiesUsecase: sl.call(),
      checkEmailRegistrationUsecase: sl.call()));

  sl.registerFactory(() => HomeViewBloc(getOwnUserProfileUsecase: sl.call()));

  sl.registerFactory(() => ProfileViewBloc(
      getUserUsecase: sl.call(), deauthenticateUsecase: sl.call()));

  sl.registerFactory(() => PostViewBloc(
      addToFavoritesUsecase: sl.call(),
      removeFromFavoritesUsecase: sl.call(),
      getAllPostsUsecase: sl.call(),
      getCachedSessionUsecase: sl.call(),
      getDetailedPostUsecase: sl.call(),
      getAllPostsByCategoryUsecase: sl.call(),
      getAllCategoriesUsecase: sl.call()));

  sl.registerFactory(() => DetailedPostViewBloc(
      addToFavoritesUsecase: sl.call(),
      checkIfFavoriteUsecase: sl.call(),
      getDetailedPostUsecase: sl.call(),
      removeFromFavoritesUsecase: sl.call()));

  sl.registerFactory(
      () => SearchViewBloc(getAllPostsByQueryUsecase: sl.call()));

  sl.registerFactory(() => AddPostViewBloc(
      getAllCategoriesUsecase: sl.call(), uploadPostUsecase: sl.call()));

  sl.registerFactory(() => FavoritesViewBloc(
      getFavoritePostsUsecase: sl.call(),
      removeFromFavoritesUsecase: sl.call()));
  // Usecases

  sl.registerLazySingleton(() => AuthenticateUsecase(repository: sl.call()));

  sl.registerLazySingleton(() => DeauthenticateUsecase(
        authSessionOperations: sl.call(),
        authSessionRepository: sl.call(),
      ));

  sl.registerLazySingleton(
      () => GetAuthenticationStatusUsecase(operations: sl.call()));
  sl.registerLazySingleton(
      () => GetCachedSessionUsecase(repository: sl.call()));

  sl.registerLazySingleton(() => CacheSessionUsecase(operations: sl.call()));

  sl.registerLazySingleton(
      () => CheckEmailAvailabilityUsecase(operations: sl.call()));

  sl.registerLazySingleton(() => GetAllFacultiesUsecase(repository: sl.call()));

  sl.registerLazySingleton(() => SignUpUsecase(operations: sl.call()));

  sl.registerLazySingleton(() =>
      GetOwnUserProfile(userRepository: sl.call(), authRepository: sl.call()));

  sl.registerLazySingleton(() =>
      GetAllPostsUsecase(postRepository: sl.call(), authRepository: sl.call()));

  sl.registerLazySingleton(() => GetDetailedPostUsecase(
      postRepository: sl.call(), authRepository: sl.call()));

  sl.registerLazySingleton(() => GetAllPostsByOwnerUsecase(
      postRepository: sl.call(), authRepository: sl.call()));

  sl.registerLazySingleton(() => GetAllPostsByCategory(
      postRepository: sl.call(), authRepository: sl.call()));

  sl.registerLazySingleton(() => GetAllPostsByQueryUsecase(
      postRepository: sl.call(), authRepository: sl.call()));

  sl.registerLazySingleton(() => GetFavoritePostsUsecase(
      postRepository: sl.call(), authRepository: sl.call()));

  sl.registerLazySingleton(() => AddToFavoritesUsecase(
      salePostOperations: sl.call(), authRepository: sl.call()));

  sl.registerLazySingleton(() => CheckIfFavoriteUsecase(
      salePostOperations: sl.call(), authRepository: sl.call()));

  sl.registerLazySingleton(() => RemoveFromFavoritesUsecase(
      salePostOperations: sl.call(), authRepository: sl.call()));

  sl.registerLazySingleton(() => GetAllCategoriesUsecase(
      categoryRepository: sl.call(), authRepository: sl.call()));

  sl.registerLazySingleton(() => UploadPostUsecase(
      salePostOperations: sl.call(), authRepository: sl.call()));

  // Repositories

  sl.registerLazySingleton<AuthSessionOperations>(() =>
      AuthSessionOperationsImpl(
          authRemoteDataSource: sl.call(), authLocalDataSource: sl.call()));

  sl.registerLazySingleton<UserOperations>(
      () => UserServicesImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<CredentialsOperations>(
      () => CredentialsOperationsImpl(credentialsRemoteDataSource: sl.call()));

  sl.registerLazySingleton<AuthSessionRepository>(() => AuthRepositoryImpl(
      remoteDataSource: sl.call(), localDataSource: sl.call()));

  sl.registerLazySingleton<FacultyRepository>(
      () => FacultyRepositoryImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<SalePostRepository>(
      () => SalePostRepositoryImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<SalePostOperations>(
      () => SalePostOperationsImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<ProductCategoryRepository>(
      () => ProductCategoryRepositoryImpl(remoteDataSource: sl.call()));
// Remote Data Source

  sl.registerLazySingleton<AuthSessionLocalDataSource>(
      () => AuthSessionLocalDataSourceImpl());

  sl.registerLazySingleton<AuthSessionRemoteDataSource>(
      () => AuthSessionRemoteDataSourceImpl());

  sl.registerLazySingleton<CredentialsRemoteDataSource>(
      () => CredentialsRemoteDataSourceImpl());

  sl.registerLazySingleton<FacultyRemoteDataSource>(
      () => FacultyRemoteDataSourceImpl());

  sl.registerLazySingleton<SalePostRemoteDataSource>(
      () => SalePostRemotedataSourceImpl());

  sl.registerLazySingleton<UserRepositoryRemoteDataSource>(
      () => UserRepositortRemoteDataSourceImpl());

  sl.registerLazySingleton<UserOperationsRemoteDataSource>(
      () => UserOperationsRemoteDataSourceImpl());

  sl.registerLazySingleton<ProductCategoryRemoteDataSource>(
      () => ProductCategoryRemoteDataSourceImpl());
  // Externals
}
