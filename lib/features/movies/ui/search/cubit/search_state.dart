import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/network/resource.dart';

class SearchState {
  final Resource<List<MovieEntity>> searchResult;
  final bool isFetchingMore;

  SearchState({required this.searchResult , this.isFetchingMore = false} );

  factory SearchState.initial(){
    return SearchState(searchResult: Resource.initial() , isFetchingMore: false);
  }
  SearchState copyWith({Resource<List<MovieEntity>>? searchResult , bool? isFetchingMore}){
    return SearchState(searchResult: searchResult ?? this.searchResult,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,);
  }
}