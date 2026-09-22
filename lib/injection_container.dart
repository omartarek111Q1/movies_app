

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:dio/dio.dart';
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
import 'features/movies/data/data_sources/local_data_source/movie_local_data_source.dart';
import 'features/movies/data/data_sources/local_data_source/movie_local_data_source_impl.dart';
import 'features/movies/data/data_sources/remote_data_source/movie_remote_data_source.dart';
import 'features/movies/data/data_sources/remote_data_source/movie_remote_data_source_impl.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/repositories/movie_repository.dart';
import 'features/movies/domain/usecases/get_movies_list_use_case.dart';
import 'features/movies/ui/home/home_cubit/home_cubit.dart';
import 'network/api/api_services.dart';
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
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://movies-api.accel.li/api/v2/" , // استبدله بالرابط الخاص بالـ API
        receiveDataWhenStatusError: true,
      ),
    );

    // يفضل إضافة LogInterceptor أثناء التطوير لمتابعة الـ API
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return dio;
  });
// مثال لتسجيل ApiServices أو Dio
  sl.registerLazySingleton(() => ApiServices(sl())); // أو تمرير Dio مباشرة
  ///movie
  sl.registerLazySingleton<MovieRemoteDataSource>(() => MovieRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<MovieLocalDataSource>(() => MovieLocalDataSourceImpl());

  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(sl(), sl(), sl()));


  sl.registerLazySingleton(() => GetMoviesListUseCase(sl()));
  sl.registerFactory(() => HomeCubit(sl()));
}
