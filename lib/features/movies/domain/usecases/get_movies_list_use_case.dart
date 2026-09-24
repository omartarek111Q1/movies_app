import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movies_app/network/api_result.dart';

class GetMoviesListUseCase {
  final MovieRepository repository;
  GetMoviesListUseCase(this.repository);

  Future<ApiResult<List<MovieEntity>>> call({int page = 1 , String? genre , String? sortBy , String? queryTerm}){
    return repository.getMoviesList(page: page, genre: genre, sortBy: sortBy , queryTerm: queryTerm );
  }
}