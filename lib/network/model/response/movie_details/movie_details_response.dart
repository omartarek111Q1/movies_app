import 'movie_details_dm.dart';
import 'dart:convert';

MovieDetailsResponse movieDetailsResponseFromJson(String str) => MovieDetailsResponse.fromJson(json.decode(str));
String movieDetailsResponseToJson(MovieDetailsResponse data) => json.encode(data.toJson());
class MovieDetailsResponse {
  MovieDetailsResponse({
      this.status, 
      this.statusMessage, 
      this.movieDetails,
      });

  MovieDetailsResponse.fromJson(dynamic json) {
    status = json['status'];
    statusMessage = json['status_message'];
    movieDetails = json['data'] != null ? MovieDetailsDM.fromJson(json['data']) : null;
  }
  String? status;
  String? statusMessage;
  MovieDetailsDM? movieDetails;
MovieDetailsResponse copyWith({  String? status,
  String? statusMessage,
  MovieDetailsDM? data,
}) => MovieDetailsResponse(  status: status ?? this.status,
  statusMessage: statusMessage ?? this.statusMessage,
  movieDetails: data ?? this.movieDetails,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['status_message'] = statusMessage;
    if (movieDetails != null) {
      map['data'] = movieDetails?.toJson();
    }
    return map;
  }

}