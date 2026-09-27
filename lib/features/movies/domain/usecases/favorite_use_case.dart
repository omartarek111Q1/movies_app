import '../../../../network/api_result.dart';
import '../entity/movie_details_entity.dart';
import '../entity/movie_entity.dart';
import '../repositories/user_actions_repository.dart';

class FavoriteUseCase {
  final UserActionsRepository repository;

  FavoriteUseCase(this.repository);

  Future<ApiResult<bool>> checkIsFavorite(int movieId) {
    return repository.isFavorite(movieId);
  }

  Future<ApiResult<int>> getFavoriteCount(int movieId) {
    return repository.getFavoriteCount(movieId);
  }

  Stream<ApiResult<List<MovieEntity>>> getFavoriteMovies() {
    return repository.getFavoriteMovies();
  }

  Future<ApiResult<void>> toggleFavorite(MovieDetailsEntity movie, bool isCurrentlyFavorite) async {
    if (isCurrentlyFavorite) {
      return await repository.removeFromFavorite(movie.id ?? 0);
    } else {
      return await repository.addToFavorite(movie);
    }
  }
}