import 'dart:convert';

import '../common/movie_dm.dart';

MovieDetailsDM dataFromJson(String str) => MovieDetailsDM.fromJson(json.decode(str));
String dataToJson(MovieDetailsDM data) => json.encode(data.toJson());
class MovieDetailsDM {
  MovieDetailsDM({
      this.movie,});

  MovieDetailsDM.fromJson(dynamic json) {
    movie = json['movie'] != null ? MovieDM.fromJson(json['movie']) : null;
  }
  MovieDM? movie;
MovieDetailsDM copyWith({  MovieDM? movie,
}) => MovieDetailsDM(  movie: movie ?? this.movie,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (movie != null) {
      map['movie'] = movie?.toJson();
    }
    return map;
  }

}