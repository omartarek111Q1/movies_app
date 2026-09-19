import '../common/movie_dm.dart';
import 'dart:convert';

MoviesDM dataFromJson(String str) => MoviesDM.fromJson(json.decode(str));
String dataToJson(MoviesDM data) => json.encode(data.toJson());
class MoviesDM {
  MoviesDM({
      this.movieCount, 
      this.limit, 
      this.pageNumber, 
      this.movies,});

  MoviesDM.fromJson(dynamic json) {
    movieCount = json['movie_count'];
    limit = json['limit'];
    pageNumber = json['page_number'];
    if (json['movies'] != null) {
      movies = [];
      json['movies'].forEach((v) {
        movies?.add(MovieDM.fromJson(v));
      });
    }
  }
  int? movieCount;
  int? limit;
  int? pageNumber;
  List<MovieDM>? movies;
MoviesDM copyWith({  int? movieCount,
  int? limit,
  int? pageNumber,
  List<MovieDM>? movies,
}) => MoviesDM(  movieCount: movieCount ?? this.movieCount,
  limit: limit ?? this.limit,
  pageNumber: pageNumber ?? this.pageNumber,
  movies: movies ?? this.movies,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['movie_count'] = movieCount;
    map['limit'] = limit;
    map['page_number'] = pageNumber;
    if (movies != null) {
      map['movies'] = movies?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}