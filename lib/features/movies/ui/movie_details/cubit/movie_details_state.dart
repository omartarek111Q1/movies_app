import 'package:movies_app/features/movies/domain/entity/movie_details_entity.dart';
import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/network/resource.dart';

class MovieDetailsState {
  final Resource<MovieDetailsEntity> movieDetails;
  final Resource<List<MovieEntity>> similarMovies;

  final bool isFavorite;
  final bool isBookMarked;
  final int favoriteCount;

  MovieDetailsState({
    required this.movieDetails,
    required this.similarMovies,
    this.favoriteCount = 0,
    this.isBookMarked = false,
    this.isFavorite = false,
  });

  factory MovieDetailsState.initial() {
    return MovieDetailsState(
      movieDetails: Resource.initial(),
      similarMovies: Resource.initial(),
    );
  }

  MovieDetailsState copyWith({
    Resource<MovieDetailsEntity>? movieDetails,
    Resource<List<MovieEntity>>? similarMovies,
    bool? isFavorite,
    bool? isBookMarked,
    int? favoriteCount,
  }) {
    return MovieDetailsState(
      movieDetails: movieDetails ?? this.movieDetails,
      similarMovies: similarMovies ?? this.similarMovies,
      isFavorite: isFavorite ?? this.isFavorite,
      isBookMarked: isBookMarked ?? this.isBookMarked,
      favoriteCount: favoriteCount ?? this.favoriteCount,
    );
  }
}
