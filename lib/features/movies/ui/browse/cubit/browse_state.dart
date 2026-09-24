import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/network/resource.dart';

class BrowseState {
  final String selectedGenre;
  final Resource<List<MovieEntity>> moviesResult;
  final bool isFetchingMore;

  BrowseState({
required this.selectedGenre,
    required this.moviesResult,
     this.isFetchingMore = false
  });

  factory BrowseState.initial(){
    return BrowseState(
        selectedGenre: 'Action',
        moviesResult: Resource.initial()
    );
  }

  BrowseState copyWith({
    String? selectedGenre,
    Resource<List<MovieEntity>>? moviesResult,
    bool? isFetchingMore,
  }) {
    return BrowseState(
      selectedGenre: selectedGenre ?? this.selectedGenre,
      moviesResult: moviesResult ?? this.moviesResult,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}