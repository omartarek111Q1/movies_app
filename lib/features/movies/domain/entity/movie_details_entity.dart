import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';

import 'cast_entity.dart';

class MovieDetailsEntity {
  final int id;
  final String image;
  final String title;
  final int year;
  final double rating;
  final num runtime;
  // final int addToFav;
  final List<String> screenShots;
  final String summary;
  final List<String> genres;
  final List<CastEntity> cast;

  MovieDetailsEntity({
    required this.id,
    required this.image,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.screenShots,
    required this.summary,
    required this.genres,
    required this.cast});
}