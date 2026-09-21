import 'package:movies_app/network/model/response/movie_details/movie_details_response.dart';

import 'package:movies_app/network/model/response/movies_list/movies_list_response.dart';

import '../../../../../network/api/api_services.dart';
import 'movie_remote_data_source.dart';

class MovieRemoteDataSourceImpl extends MovieRemoteDataSource{
final ApiServices _apiServices;
MovieRemoteDataSourceImpl(this._apiServices);

  @override
  Future<MovieDetailsResponse> getMoviesDetails({required int movieID}) {
    return _apiServices.getMovieDetails(movieID);

  }

  @override
  Future<MoviesListResponse> getMoviesList({int page = 1}) {
    return _apiServices.getMoviesList(page);
  }

  @override
  Future<MoviesListResponse> getMoviesSuggestions({required int movieID}) {
    return _apiServices.getMovieSuggestions(movieID);
  }

}