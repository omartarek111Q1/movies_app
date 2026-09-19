import 'package:movies_app/features/movies/domain/entity/movie_details_entity.dart';
import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/network/api_result.dart';

abstract class MovieRepository {
  Future<ApiResult<List<MovieEntity>>> getMoviesList({int page = 1}); // add int page = 1 bec  pagination

  Future<ApiResult<MovieDetailsEntity>> getMovieDetails({required int movieID});

  Future<ApiResult<List<MovieEntity>>> getMovieSuggestions({required int movieID});
}