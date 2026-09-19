import 'movies_dm.dart';
import 'dart:convert';

MoviesListResponse moviesListResponseFromJson(String str) => MoviesListResponse.fromJson(json.decode(str));
String moviesListResponseToJson(MoviesListResponse data) => json.encode(data.toJson());
class MoviesListResponse {
  MoviesListResponse({
      this.status, 
      this.statusMessage, 
      this.movies,});

  MoviesListResponse.fromJson(dynamic json) {
    status = json['status'];
    statusMessage = json['status_message'];
    movies = json['data'] != null ? MoviesDM.fromJson(json['data']) : null;
  }
  String? status;
  String? statusMessage;
  MoviesDM? movies;
MoviesListResponse copyWith({  String? status,
  String? statusMessage,
  MoviesDM? data,
}) => MoviesListResponse(  status: status ?? this.status,
  statusMessage: statusMessage ?? this.statusMessage,
  movies: data ?? this.movies,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['status_message'] = statusMessage;
    if (movies != null) {
      map['data'] = movies?.toJson();
    }
    return map;
  }

}