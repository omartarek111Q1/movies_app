

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'features/authentication/data/data_sources/remote_data_source/auth_remote_data_source.dart';
import 'features/authentication/data/data_sources/remote_data_source/auth_remote_data_source_impl.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/usecases/first_page_use_case.dart';
import 'features/authentication/domain/repositories/authentication_repository.dart';
import 'features/authentication/domain/usecases/check_verification_use_case.dart';
import 'features/authentication/domain/usecases/google_auth_use_case.dart';
import 'features/authentication/domain/usecases/logout_use_case.dart';
import 'features/authentication/domain/usecases/sign_in_use_case.dart';
import 'features/authentication/domain/usecases/sign_up_use_case.dart';
import 'features/authentication/domain/usecases/verify_email_use_case.dart';
import 'features/authentication/ui/cubit/auth_cubit.dart';
import 'network/check_network/network_info.dart';
import 'network/check_network/network_info_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! Features - posts

// Bloc

  sl.registerFactory(() => AuthCubit(signInUseCase: sl(), signUpUseCase: sl(), firstPage: sl() , verifyEmailUseCase: sl(), checkVerificationUseCase:sl(), logOutUseCase: sl(), googleAuthUseCase: sl()));


// Usecases

  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => FirstPageUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => CheckVerificationUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GoogleAuthUseCase(sl()));

// Repository

  sl.registerLazySingleton<AuthenticationRepository>(() => AuthRepositoryImpl(networkInfo: sl(), authRemoteDataSource: sl()));

// Datasources

  sl.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl());

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External

  sl.registerLazySingleton(() => InternetConnection());

}
