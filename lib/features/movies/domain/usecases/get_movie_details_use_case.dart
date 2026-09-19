import 'package:movies_app/features/movies/domain/entity/movie_details_entity.dart';
import 'package:movies_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movies_app/network/api_result.dart';

class GetMovieDetailsUseCase {
  final MovieRepository repository;
  GetMovieDetailsUseCase(this.repository);

  Future<ApiResult<MovieDetailsEntity>> call({required int movieID}){
    return repository.getMovieDetails(movieID: movieID);
  }
}