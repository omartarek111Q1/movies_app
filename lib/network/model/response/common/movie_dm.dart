import 'dart:convert';
import 'cast_dm.dart';
import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/features/movies/domain/entity/movie_details_entity.dart';

MovieDM moviesFromJson(String str) => MovieDM.fromJson(json.decode(str));
String moviesToJson(MovieDM data) => json.encode(data.toJson());
class MovieDM {
  MovieDM({
      this.id, 
      this.url, 
      this.imdbCode, 
      this.title, 
      this.titleEnglish, 
      this.titleLong, 
      this.slug, 
      this.year, 
      this.rating, 
      this.runtime, 
      this.genres, 
      this.summary, 
      this.descriptionFull, 
      this.synopsis, 
      this.ytTrailerCode, 
      this.language, 
      this.mpaRating, 
      this.backgroundImage, 
      this.backgroundImageOriginal, 
      this.smallCoverImage, 
      this.mediumCoverImage, 
      this.largeCoverImage, 
      this.state, 
      this.dateUploaded,
      this.dateUploadedUnix,
      this.mediumScreenshotImage1,
      this.mediumScreenshotImage2,
      this.mediumScreenshotImage3,
      this.cast,});

  MovieDM.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    imdbCode = json['imdb_code'];
    title = json['title'];
    titleEnglish = json['title_english'];
    titleLong = json['title_long'];
    slug = json['slug'];
    year = json['year'];
    rating = (json['rating'] as num).toDouble();
    runtime = json['runtime'];
    genres = json['genres'] != null ? json['genres'].cast<String>() : [];
    summary = json['summary'];
    descriptionFull = json['description_full'];
    synopsis = json['synopsis'];
    ytTrailerCode = json['yt_trailer_code'];
    language = json['language'];
    mpaRating = json['mpa_rating'];
    backgroundImage = json['background_image'];
    backgroundImageOriginal = json['background_image_original'];
    smallCoverImage = json['small_cover_image'];
    mediumCoverImage = json['medium_cover_image'];
    largeCoverImage = json['large_cover_image'];
    state = json['state'];
    dateUploaded = json['date_uploaded'];
    dateUploadedUnix = json['date_uploaded_unix'];
    mediumScreenshotImage1 = json['medium_screenshot_image1'];
    mediumScreenshotImage2 = json['medium_screenshot_image2'];
    mediumScreenshotImage3 = json['medium_screenshot_image3'];
    if (json['cast'] != null) {
      cast = [];
      json['cast'].forEach((v) {
        cast?.add(CastDM.fromJson(v));
      });
    }
  }
  int? id;
  String? url;
  String? imdbCode;
  String? title;
  String? titleEnglish;
  String? titleLong;
  String? slug;
  int? year;
  double? rating;
  int? runtime;
  List<String>? genres;
  String? summary;
  String? descriptionFull;
  String? synopsis;
  String? ytTrailerCode;
  String? language;
  String? mpaRating;
  String? backgroundImage;
  String? backgroundImageOriginal;
  String? smallCoverImage;
  String? mediumCoverImage;
  String? largeCoverImage;
  String? state;
  String? dateUploaded;
  int? dateUploadedUnix;
  String? mediumScreenshotImage1;
  String? mediumScreenshotImage2;
  String? mediumScreenshotImage3;
  List<CastDM>? cast;
MovieDM copyWith({  int? id,
  String? url,
  String? imdbCode,
  String? title,
  String? titleEnglish,
  String? titleLong,
  String? slug,
  int? year,
  double? rating,
  int? runtime,
  List<String>? genres,
  String? summary,
  String? descriptionFull,
  String? synopsis,
  String? ytTrailerCode,
  String? language,
  String? mpaRating,
  String? backgroundImage,
  String? backgroundImageOriginal,
  String? smallCoverImage,
  String? mediumCoverImage,
  String? largeCoverImage,
  String? state,
  String? dateUploaded,
  int? dateUploadedUnix,
}) => MovieDM(  id: id ?? this.id,
  url: url ?? this.url,
  imdbCode: imdbCode ?? this.imdbCode,
  title: title ?? this.title,
  titleEnglish: titleEnglish ?? this.titleEnglish,
  titleLong: titleLong ?? this.titleLong,
  slug: slug ?? this.slug,
  year: year ?? this.year,
  rating: rating ?? this.rating,
  runtime: runtime ?? this.runtime,
  genres: genres ?? this.genres,
  summary: summary ?? this.summary,
  descriptionFull: descriptionFull ?? this.descriptionFull,
  synopsis: synopsis ?? this.synopsis,
  ytTrailerCode: ytTrailerCode ?? this.ytTrailerCode,
  language: language ?? this.language,
  mpaRating: mpaRating ?? this.mpaRating,
  backgroundImage: backgroundImage ?? this.backgroundImage,
  backgroundImageOriginal: backgroundImageOriginal ?? this.backgroundImageOriginal,
  smallCoverImage: smallCoverImage ?? this.smallCoverImage,
  mediumCoverImage: mediumCoverImage ?? this.mediumCoverImage,
  largeCoverImage: largeCoverImage ?? this.largeCoverImage,
  state: state ?? this.state,
  dateUploaded: dateUploaded ?? this.dateUploaded,
  dateUploadedUnix: dateUploadedUnix ?? this.dateUploadedUnix,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['url'] = url;
    map['imdb_code'] = imdbCode;
    map['title'] = title;
    map['title_english'] = titleEnglish;
    map['title_long'] = titleLong;
    map['slug'] = slug;
    map['year'] = year;
    map['rating'] = rating;
    map['runtime'] = runtime;
    map['genres'] = genres;
    map['summary'] = summary;
    map['description_full'] = descriptionFull;
    map['synopsis'] = synopsis;
    map['yt_trailer_code'] = ytTrailerCode;
    map['language'] = language;
    map['mpa_rating'] = mpaRating;
    map['background_image'] = backgroundImage;
    map['background_image_original'] = backgroundImageOriginal;
    map['small_cover_image'] = smallCoverImage;
    map['medium_cover_image'] = mediumCoverImage;
    map['large_cover_image'] = largeCoverImage;
    map['state'] = state;
    map['date_uploaded'] = dateUploaded;
    map['date_uploaded_unix'] = dateUploadedUnix;
    map['medium_screenshot_image1'] = mediumScreenshotImage1;
    map['medium_screenshot_image2'] = mediumScreenshotImage2;
    map['medium_screenshot_image3'] = mediumScreenshotImage3;
    if (cast != null) {
      map['cast'] = cast?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  MovieEntity toEntity() {
    return MovieEntity(
      id: id ?? 0,
      image: largeCoverImage ?? mediumCoverImage ?? '',
      rating: rating ?? 0.0,
    );
  }

  MovieDetailsEntity toDetailsEntity() {
    return MovieDetailsEntity(
      id: id ?? 0,
      image: largeCoverImage ?? mediumCoverImage ?? '',
      title: title ?? '',
      year: year ?? 0,
      rating: rating ?? 0.0,
      runtime: runtime ?? 0,
      screenShots: [
        if (mediumScreenshotImage1 != null) mediumScreenshotImage1!,
        if (mediumScreenshotImage2 != null) mediumScreenshotImage2!,
        if (mediumScreenshotImage3 != null) mediumScreenshotImage3!,
      ],
      summary: descriptionFull ?? summary ?? '',
      genres: genres ?? [],
      cast: cast?.map((e) => e.toEntity()).toList() ?? [],
    );
  }

}




