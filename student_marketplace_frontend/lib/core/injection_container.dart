import 'package:get_it/get_it.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/auth_session_local_data_source.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/auth_session_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/credentials_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/faculty_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/implementations/auth_session_local_data_source_impl.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/implementations/auth_session_remote_data_source_impl.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/implementations/credentials_remote_data_source_impl.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/implementations/faculty_remote_data_source_impl.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/operations/auth_session_operations_impl.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/operations/credentials_operations_impl.dart';
import 'package:student_marketplace_frontend/features/data/repositories/faculty_repository_impl.dart';
import 'package:student_marketplace_frontend/features/domain/operations/auth_session_operations.dart';
import 'package:student_marketplace_frontend/features/domain/operations/credentials_operations.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/auth_session_repository.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/faculty_repository.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/authentication/authenticate_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/authentication/deauthenticate_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/authentication/get_authentication_status_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/authentication/get_cached_session_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/credentials/check_email_availability_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/faculty/get_all_faculties_usecase.dart';
import 'package:student_marketplace_frontend/features/presentation/home/home_cubit.dart';
import 'package:student_marketplace_frontend/features/presentation/posts_view/posts_view.cubit.dart';
import 'package:student_marketplace_frontend/features/presentation/register/register_cubit.dart';

import '../features/data/data_sources/contracts/sale_post_remote_data_source.dart';
import '../features/data/data_sources/contracts/user_repository_remote_data_source.dart';
import '../features/data/data_sources/contracts/user_services_remote_data_source.dart';
import '../features/data/data_sources/implementations/sale_post_remote_data_source_impl.dart';
import '../features/data/data_sources/implementations/user_repository_remote_data_source_impl.dart';
import '../features/data/data_sources/implementations/user_operations_remote_data_source_impl.dart';
import '../features/data/repositories/auth_repository_impl.dart';
import '../features/data/repositories/sale_post_repository_impl.dart';
import '../features/data/repositories/user_repository_impl.dart';
import '../features/data/data_sources/operations/user_operations_impl.dart';
import '../features/domain/repositories/sale_post_repository.dart';
import '../features/domain/repositories/user_repository.dart';
import '../features/domain/operations/user_operations.dart';
import '../features/domain/usecases/sale_post/get_all_posts_by_category_usecase.dart';
import '../features/domain/usecases/sale_post/get_all_posts_by_owner_usecase.dart';
import '../features/domain/usecases/sale_post/get_all_posts_usecase.dart';
import '../features/domain/usecases/user/get_user_usecase.dart';
import '../features/domain/usecases/user/sign_up_usecase.dart';
import '../features/presentation/authentication/auth_cubit.dart';
import '../features/presentation/login/login_cubit.dart';
import '../features/presentation/user_profile/profile_cubit.dart';

/// Service locator
///
final sl = GetIt.instance;

Future<void> init() async {
  // Cubits

  sl.registerFactory(() => LoginCubit(
        signUpUsecase: sl.call(),
        authenticateUsecase: sl.call(),
        checkEmailAvailabilityUsecase: sl.call(),
      ));

  sl.registerFactory(() => AuthCubit(
      authenticationStatusUsecase: sl.call(),
      deauthenticateUsecase: sl.call(),
      getCachedSessionUsecase: sl.call()));

  sl.registerFactory(() => RegisterCubit(
      signUpUsecase: sl.call(),
      getAllFacultiesUsecase: sl.call(),
      checkEmailRegistrationUsecase: sl.call()));

  sl.registerFactory(() => HomeCubit());

  sl.registerFactory(() => ProfileCubit(getUserUsecase: sl.call()));

  sl.registerFactory(() => PostViewCubit(
      getAllPostsUsecase: sl.call(), getCachedSessionUsecase: sl.call()));

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

  sl.registerLazySingleton(
      () => CheckEmailAvailabilityUsecase(operations: sl.call()));

  sl.registerLazySingleton(() => GetAllFacultiesUsecase(repository: sl.call()));

  sl.registerLazySingleton(() => SignUpUsecase(repository: sl.call()));
  sl.registerLazySingleton(() =>
      GetUserUsecase(userRepository: sl.call(), authRepository: sl.call()));

  sl.registerLazySingleton(() =>
      GetAllPostsUsecase(postRepository: sl.call(), authRepository: sl.call()));
  sl.registerLazySingleton(() => GetAllPostsByOwnerUsecase(
      postRepository: sl.call(), authRepository: sl.call()));
  sl.registerLazySingleton(() => GetAllPostsByCategory(
      postRepository: sl.call(), authRepository: sl.call()));

  // Repositories

  sl.registerLazySingleton<AuthSessionOperations>(
      () => AuthSessionOperationsImpl(authRemoteDataSource: sl.call()));

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
  // Externals
}
