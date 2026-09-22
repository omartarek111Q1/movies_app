import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import '../../../../../network/resource.dart'; // تأكد من مسار الاستيراد

class HomeState {
  final Resource<List<MovieEntity>> availableNowMovies;
  final Resource<List<MovieEntity>> actionMovies;
  final Resource<List<MovieEntity>> comedyMovies;

  HomeState({
    required this.availableNowMovies,
    required this.actionMovies,
    required this.comedyMovies,
  });

  factory HomeState.initial() {
    return HomeState(
      availableNowMovies: Resource.initial(),
      actionMovies: Resource.initial(),
      comedyMovies: Resource.initial(),
    );
  }

  HomeState copyWith({
    Resource<List<MovieEntity>>? availableNowMovies,
    Resource<List<MovieEntity>>? actionMovies,
    Resource<List<MovieEntity>>? comedyMovies,
  }) {
    return HomeState(
      availableNowMovies: availableNowMovies ?? this.availableNowMovies,
      actionMovies: actionMovies ?? this.actionMovies,
      comedyMovies: comedyMovies ?? this.comedyMovies,
    );
  }
}