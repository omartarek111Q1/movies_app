import 'package:movies_app/features/movies/data/data_sources/remote_data_source/movie_remote_data_source.dart';
import 'package:movies_app/features/movies/domain/entity/movie_details_entity.dart';
import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movies_app/network/api_result.dart';
import 'package:movies_app/network/check_network/network_info.dart';

import '../data_sources/local_data_source/movie_local_data_source.dart';
import '../models/local/movie_local_model.dart';

class MovieRepositoryImpl extends MovieRepository {
  final MovieLocalDataSource movieLocalDataSource;
  final MovieRemoteDataSource movieRemoteDataSource;
  final NetworkInfo networkInfo;
  MovieRepositoryImpl(
    this.movieRemoteDataSource,
    this.movieLocalDataSource,
    this.networkInfo,
  );

  @override
  Future<ApiResult<MovieDetailsEntity>> getMovieDetails({
    required int movieID,
  }) async {
    try {
      var response = await movieRemoteDataSource.getMoviesDetails(
        movieID: movieID,
      );
      var movieModel = response.movieDetails?.movie;
      if (movieModel == null) {
        return FailureApiResult(ServerError());
      }
      return SuccessApiResult(data: movieModel.toDetailsEntity());
    } catch (e) {
      print(
        "////////////////////////////////////////the error is $e///////////////////////////////",
      );
      return FailureApiResult(ServerError());
    }
  }

  @override
  Future<ApiResult<List<MovieEntity>>> getMovieSuggestions({
    required int movieID,
  }) async {
    try {
      var response = await movieRemoteDataSource.getMoviesSuggestions(
        movieID: movieID,
      );
      List<MovieEntity> movieSuggestions =
          response.movies?.movies?.map((movieModel) {
            return MovieEntity(
              id: movieModel.id ?? 0,
              image: movieModel.mediumCoverImage ?? "",
              rating: movieModel.rating ?? 0.0,
            );
          }).toList() ??
          [];

      return SuccessApiResult(data: movieSuggestions);
    } catch (e) {
      print(
        "////////////////////////////////////////the error is $e///////////////////////////////",
      );
      return FailureApiResult(ServerError());
    }
  }

  // @override
  // Future<ApiResult<List<MovieEntity>>> getMoviesList({int page = 1 , String? genre , String? sortBy , String? queryTerm}) async{
  //   final String cacheKey = "movies_list_page_$page";
  //   if(await networkInfo.isConnected){
  //     try{
  //       var response = await movieRemoteDataSource.getMoviesList(page: page , genre: genre, sortBy: sortBy, queryTerm: queryTerm);
  //       List<MovieEntity> movieList = response.movies?.movies?.map((movieModel){
  //         return MovieEntity(
  //           id: movieModel.id ?? 0,
  //           image:  movieModel.mediumCoverImage ?? '',
  //           rating: movieModel.rating ?? 0.0,
  //         );
  //       }).toList() ?? [];
  //
  //       List<MovieLocalModel> localMoviesToCache = response.movies?.movies?.map((movieModel){
  //         return MovieLocalModel(
  //           id: movieModel.id ?? 0,
  //           image:  movieModel.mediumCoverImage ?? '',
  //           rating: movieModel.rating ?? 0.0,
  //         );
  //       }).toList() ?? [];
  //       await movieLocalDataSource.saveMovieListData(movies: localMoviesToCache, cacheKey: cacheKey);
  //
  //       return SuccessApiResult(data: movieList);
  //
  //     }catch(e){
  //       print("////////////////////////////////////////the error is $e///////////////////////////////");
  //       return FailureApiResult(ServerError());
  //     }
  //
  //   }else{
  //     try{
  //       List<MovieLocalModel> cachedMovies = await movieLocalDataSource.loadMovieListData(cacheKey: cacheKey);
  //       if(cachedMovies.isNotEmpty){
  //         List<MovieEntity> offlineMoviesList = cachedMovies.map((localMovie){
  //           return MovieEntity(
  //             id: localMovie.id,
  //             image:  localMovie.image,
  //             rating: localMovie.rating,
  //           );
  //         }).toList();
  //         return SuccessApiResult(data: offlineMoviesList);
  //       }else{
  //         return FailureApiResult(NetworkError());
  //       }
  //     }catch(e){
  //       print("////////////////////////////////////////the error is $e///////////////////////////////");
  //       return FailureApiResult(ServerError());
  //     }
  //   }
  //
  // }

  @override
  Future<ApiResult<List<MovieEntity>>> getMoviesList({
    int page = 1,
    String? genre,
    String? sortBy,
    String? queryTerm,
  }) async {
    final bool isSearch = queryTerm != null && queryTerm.isNotEmpty;

    final String cacheKey =
        "movies_list_page_${page}_genre_${genre ?? 'all'}_sort_${sortBy ?? 'none'}";

    if (await networkInfo.isConnected) {
      try {
        var response = await movieRemoteDataSource.getMoviesList(
          page: page,
          genre: genre,
          sortBy: sortBy,
          queryTerm: queryTerm,
        );

        List<MovieEntity> movieList =
            response.movies?.movies?.map((movieModel) {
              return MovieEntity(
                id: movieModel.id ?? 0,
                image: movieModel.mediumCoverImage ?? '',
                rating: movieModel.rating ?? 0.0,
              );
            }).toList() ??
            [];

        if (!isSearch) {
          List<MovieLocalModel> localMoviesToCache =
              response.movies?.movies?.map((movieModel) {
                return MovieLocalModel(
                  id: movieModel.id ?? 0,
                  image: movieModel.mediumCoverImage ?? '',
                  rating: movieModel.rating ?? 0.0,
                );
              }).toList() ??
              [];
          await movieLocalDataSource.saveMovieListData(
            movies: localMoviesToCache,
            cacheKey: cacheKey,
          );
        }

        return SuccessApiResult(data: movieList);
      } catch (e) {
        print("////////////////the error is $e////////////////");
        return FailureApiResult(ServerError());
      }
    } else {
      if (isSearch) {
        return FailureApiResult(NetworkError());
      } else {
        try {
          List<MovieLocalModel> cachedMovies = await movieLocalDataSource
              .loadMovieListData(cacheKey: cacheKey);
          if (cachedMovies.isNotEmpty) {
            List<MovieEntity> offlineMoviesList = cachedMovies.map((
              localMovie,
            ) {
              return MovieEntity(
                id: localMovie.id,
                image: localMovie.image,
                rating: localMovie.rating,
              );
            }).toList();
            return SuccessApiResult(data: offlineMoviesList);
          } else {
            return FailureApiResult(NetworkError());
          }
        } catch (e) {
          print("////////////////the error is $e////////////////");
          return FailureApiResult(ServerError());
        }
      }
    }
  }
}

