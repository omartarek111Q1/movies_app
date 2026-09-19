import 'package:dio/dio.dart';
import 'package:movies_app/network/model/response/movie_details/movie_details_response.dart';
import 'package:movies_app/network/model/response/movies_list/movies_list_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: "https://movies-api.accel.li/api/v2/")
abstract class ApiServices {
  factory ApiServices(Dio dio, {String baseUrl}) = _ApiServices;

  @GET("list_movies.json")
  Future<MoviesListResponse> getMoviesList(@Query("page") int pag);

  @GET("movie_details.json")
  Future<MovieDetailsResponse> getMovieDetails(@Query("movie_id") int movieID);

  @GET("movie_suggestions.json")
  Future<MoviesListResponse> getMovieSuggestions(
    @Query("movie_id") int movieID,
  );
}
