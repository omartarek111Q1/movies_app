import 'package:movies_app/network/model/response/movie_details/movie_details_response.dart';
import 'package:movies_app/network/model/response/movies_list/movies_list_response.dart';

abstract class MovieRemoteDataSource {
  Future<MoviesListResponse> getMoviesList({int page = 1});
  Future<MovieDetailsResponse> getMoviesDetails({required int movieID});
  Future<MoviesListResponse> getMoviesSuggestions({required int movieID});

}