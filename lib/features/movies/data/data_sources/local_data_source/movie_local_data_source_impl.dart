import 'package:hive_flutter/adapters.dart';
import 'package:movies_app/features/movies/data/data_sources/local_data_source/movie_local_data_source.dart';
import 'package:movies_app/features/movies/data/models/local/movie_local_model.dart';

class MovieLocalDataSourceImpl extends MovieLocalDataSource {

  @override
  Future<void> saveGenres(List<String> genres) async {
    var box = await Hive.openBox("genres_box");
    await box.put("cached_genres", genres);
  }

  @override
  Future<List<String>> loadGenres() async {
    var box = await Hive.openBox("genres_box");
    return box.get("cached_genres")?.cast<String>() ?? [];
  }

  @override
  Future<void> saveMovieListData({required List<MovieLocalModel> movies, required String cacheKey}) async {
    var box = await Hive.openBox('movies_box');
    await box.put(cacheKey, movies);
  }

  @override
  Future<List<MovieLocalModel>> loadMovieListData({required String cacheKey}) async {
    var box = await Hive.openBox("movies_box");
    var data = box.get(cacheKey);
    if (data != null) {
      return List<MovieLocalModel>.from(data);
    }
    return [];
  }
}