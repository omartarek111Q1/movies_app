
import '../../models/local/movie_local_model.dart';

abstract class MovieLocalDataSource {
  Future<List<MovieLocalModel>> loadMovieListData({required String cacheKey});
 Future<void> saveMovieListData({required List<MovieLocalModel> movies , required String cacheKey});

 Future<List<String>> loadGenres();
 Future<void> saveGenres(List<String> genres);
}