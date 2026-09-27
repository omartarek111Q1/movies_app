import '../../../../network/api_result.dart';
import '../entity/movie_details_entity.dart';
import '../entity/movie_entity.dart';
import '../repositories/user_actions_repository.dart';

class BookMarkUseCase {
  final UserActionsRepository repository;

  BookMarkUseCase(this.repository);

  Future<ApiResult<bool>> checkIsBookmarked(int movieId) {
    return repository.isBookmarked(movieId);
  }

  Stream<ApiResult<List<MovieEntity>>> getBookmarkedMovies() {
    return repository.getBookmarkedMovies();
  }

  Future<ApiResult<void>> toggleBookmark(MovieDetailsEntity movie, bool isCurrentlyBookmarked) async {
    if (isCurrentlyBookmarked) {
      return await repository.removeFromBookmark(movie.id ?? 0);
    } else {
      return await repository.addToBookmark(movie);
    }
  }
}