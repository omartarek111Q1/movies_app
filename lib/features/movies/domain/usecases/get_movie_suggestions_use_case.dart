import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movies_app/network/api_result.dart';

class GetMovieSuggestionsUseCase {
  final MovieRepository repository;
  GetMovieSuggestionsUseCase(this.repository);

  Future<ApiResult<List<MovieEntity>>> call({required int movieID}){
    return repository.getMovieSuggestions(movieID: movieID);
  }
}