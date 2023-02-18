import 'package:get_it/get_it.dart';
import '../features/data/data_sources/contracts/sale_post_remote_data_source.dart';
import '../features/data/data_sources/contracts/user_repository_remote_data_source.dart';
import '../features/data/data_sources/contracts/user_services_remote_data_source.dart';
import '../features/data/data_sources/implementations/sale_post_remote_data_source_impl.dart';
import '../features/data/data_sources/implementations/user_repository_remote_data_source_impl.dart';
import '../features/data/data_sources/implementations/user_services_local_data_source_impl.dart';
import '../features/data/data_sources/implementations/user_services_remote_data_source_impl.dart';
import '../features/data/repositories/sale_post_repository_impl.dart';
import '../features/domain/repositories/sale_post_repository.dart';
import '../features/domain/repositories/user_repository.dart';
import '../features/domain/repositories/user_services.dart';
import '../features/domain/usecases/sale_post/get_all_posts_by_category_usecase.dart';
import '../features/domain/usecases/sale_post/get_all_posts_by_owner_usecase.dart';
import '../features/domain/usecases/sale_post/get_all_posts_usecase.dart';
import '../features/domain/usecases/user/get_auth_token_usecase.dart';
import '../features/domain/usecases/user/get_user_usecase.dart';
import '../features/domain/usecases/user/is_signed_in_usecase.dart';
import '../features/domain/usecases/user/sign_in_usecase.dart';
import '../features/domain/usecases/user/sign_out_usecase.dart';
import '../features/domain/usecases/user/sign_up_usecase.dart';
import '../features/presentation/authentication/auth_cubit.dart';
import '../features/presentation/login/login_cubit.dart';

import '../features/data/data_sources/contracts/user_services_local_data_source.dart';
import '../features/data/repositories/user_repository_impl.dart';
import '../features/data/repositories/user_services_impl.dart';

/// Service locator
///
final sl = GetIt.instance;

Future<void> init() async {
  // Cubits

  sl.registerFactory(
      () => LoginCubit(signInUsecase: sl.call(), signUpUsecase: sl.call()));

  sl.registerFactory(() => AuthCubit(
      isSignedInUsecase: sl.call(),
      signOutUsecase: sl.call(),
      getAuthTokenUsecase: sl.call()));
  // Usecases

  sl.registerLazySingleton(() => GetAuthToken(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignedInUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => SignOutUsecase(repository: sl.call()));

  sl.registerLazySingleton(() => GetUserUsecase(repository: sl.call()));

  sl.registerLazySingleton(() => GetAllPostsUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetAllPostsByCategory(repository: sl.call()));
  sl.registerLazySingleton(
      () => GetAllPostsByOwnerUsecase(repository: sl.call()));

  // Repositories

  sl.registerLazySingleton<UserServices>(() => UserServicesImpl(
      remoteDataSource: sl.call(), localDataSource: sl.call()));
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl.call()));
  sl.registerLazySingleton<SalePostRepository>(
      () => SalePostRepositoryImpl(remoteDataSource: sl.call()));

// Remote Data Source
  sl.registerLazySingleton<UserServicesLocalDataSource>(
      () => UserServicesLocalDataSourceImpl());

  sl.registerLazySingleton<UserServicesRemoteDataSource>(
      () => UserServicesRemoteDataSourceImpl());

  sl.registerLazySingleton<UserRepositoryRemoteDataSource>(
      () => UserRepositortRemoteDataSourceImpl());

  sl.registerLazySingleton<SalePostRemoteDataSource>(
      () => SalePostRemotedataSourceImpl());

  // Externals
}
