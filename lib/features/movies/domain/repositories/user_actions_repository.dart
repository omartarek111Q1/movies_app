import '../../../../network/api_result.dart';
import '../entity/movie_details_entity.dart';
import '../entity/movie_entity.dart';

abstract class UserActionsRepository {
  Future<ApiResult<void>> addToFavorite(MovieDetailsEntity movie);
  Future<ApiResult<void>> removeFromFavorite(int movieId);
  Future<ApiResult<bool>> isFavorite(int movieId);
  Future<ApiResult<int>> getFavoriteCount(int movieId);
  Stream<ApiResult<List<MovieEntity>>> getFavoriteMovies();

  Future<ApiResult<void>> addToBookmark(MovieDetailsEntity movie);
  Future<ApiResult<void>> removeFromBookmark(int movieId);
  Future<ApiResult<bool>> isBookmarked(int movieId);
  Stream<ApiResult<List<MovieEntity>>> getBookmarkedMovies();
}