import '../../../../domain/entity/movie_details_entity.dart';
import '../../../../domain/entity/movie_entity.dart';

abstract class UserActionsRemoteDataSource {

  Future<void> addToFavorite(MovieDetailsEntity movie);
  Future<void> removeFromFavorite(int movieId);
  Future<bool> isFavorite(int movieId);
  Future<int> getFavoriteCount(int movieId);

  Future<void> addToBookmark(MovieDetailsEntity movie);
  Future<void> removeFromBookmark(int movieId);
  Future<bool> isBookmarked(int movieId);

  Stream<List<MovieEntity>> getFavoriteMovies();
  Stream<List<MovieEntity>> getBookmarkedMovies();
}