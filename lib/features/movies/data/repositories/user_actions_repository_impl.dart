import 'package:movies_app/features/movies/data/repositories/user_actions_repository_impl.dart' as remoteDataSource;
import 'package:movies_app/features/movies/domain/entity/movie_details_entity.dart';
import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/features/movies/domain/repositories/user_actions_repository.dart';
import 'package:movies_app/network/api_result.dart';

import '../data_sources/remote_data_source/user_actions/UserActionsRemoteDataSource.dart';

class UserActionsRepositoryImpl extends UserActionsRepository {

  final UserActionsRemoteDataSource remoteDataSource;

  UserActionsRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<ApiResult<void>> addToBookmark(MovieDetailsEntity movie)async {
    try {
      await remoteDataSource.addToBookmark(movie);
      return SuccessApiResult(data: null);
    } catch (e) {
      return FailureApiResult(Errors(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> addToFavorite(MovieDetailsEntity movie)async {
    try {
      await remoteDataSource.addToFavorite(movie);
      return SuccessApiResult(data: null);
    } catch (e) {
      return FailureApiResult(Errors(e.toString()));
    }
  }

  @override
  Future<ApiResult<int>> getFavoriteCount(int movieId)async {
    try {
      final count = await remoteDataSource.getFavoriteCount(movieId);
      return SuccessApiResult(data: count);
    } catch (e) {
      return FailureApiResult(Errors(e.toString()));
    }
  }

  @override
  Future<ApiResult<bool>> isBookmarked(int movieId)async {
    try {
      final result = await remoteDataSource.isBookmarked(movieId);
      return SuccessApiResult(data: result);
    } catch (e) {
      return FailureApiResult(Errors(e.toString()));
    }
  }

  @override
  Future<ApiResult<bool>> isFavorite(int movieId)async {
    try {
      final result = await remoteDataSource.isFavorite(movieId);
      return SuccessApiResult(data: result);
    } catch (e) {
      return FailureApiResult(Errors(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> removeFromBookmark(int movieId)async {
    try {
      await remoteDataSource.removeFromBookmark(movieId);
      return SuccessApiResult(data: null);
    } catch (e) {
      return FailureApiResult(Errors(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> removeFromFavorite(int movieId)async {
    try {
      await remoteDataSource.removeFromFavorite(movieId);
      return SuccessApiResult(data: null);
    } catch (e) {
      return FailureApiResult(Errors(e.toString()));
    }
  }

  @override
  Stream<ApiResult<List<MovieEntity>>> getBookmarkedMovies() {
    return remoteDataSource.getBookmarkedMovies().map((movies) {
      return SuccessApiResult(data: movies) as ApiResult<List<MovieEntity>>;
    }).handleError((error) {
      return FailureApiResult(Errors(error.toString())) as ApiResult<List<MovieEntity>>;
    });
  }

  @override
  Stream<ApiResult<List<MovieEntity>>> getFavoriteMovies() {
    return remoteDataSource.getFavoriteMovies().map((movies) {
      return SuccessApiResult(data: movies) as ApiResult<List<MovieEntity>>;
    }).handleError((error) {
      return FailureApiResult(Errors(error.toString())) as ApiResult<List<MovieEntity>>;
    });
  }
  }

