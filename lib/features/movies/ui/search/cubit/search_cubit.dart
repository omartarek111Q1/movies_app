import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/movies/domain/usecases/get_movies_list_use_case.dart';
import 'package:movies_app/features/movies/ui/search/cubit/search_state.dart';
import 'package:movies_app/network/resource.dart';

import '../../../domain/entity/movie_entity.dart';

class SearchCubit extends Cubit<SearchState>{
  final GetMoviesListUseCase getMoviesListUseCase;

  int currentPage = 1;
  String currentQuery = '';
  final List<MovieEntity> currentMovies = [];
  bool hasReachedMax = false;

  SearchCubit(this.getMoviesListUseCase) : super(SearchState.initial());

  Future<void> searchMovie(String query) async {
    if(query.isEmpty){
      currentQuery = '';
    currentMovies.clear();
      emit(state.copyWith(searchResult: Resource.initial()));
      return;
    }

    currentPage = 1;
    currentQuery = query;
    currentMovies.clear();
    hasReachedMax = false;

    emit(state.copyWith(searchResult: Resource.loading()));

    var apiResult = await getMoviesListUseCase.call(queryTerm: query , page: currentPage );
    if(apiResult.isSuccess){
      final newMovies = apiResult.getData() ?? [];
      currentMovies.addAll(newMovies);
      if(newMovies.isEmpty || newMovies.length < 20) hasReachedMax = true;
      emit(state.copyWith(searchResult: Resource.success(List.from(currentMovies))));
    }else{
      emit(state.copyWith(searchResult: Resource.error(apiResult.errorMessage)));
    }
  }

  Future<void> loadMore() async{
    if(state.isFetchingMore || hasReachedMax || currentQuery.isEmpty) return;

    emit(state.copyWith(isFetchingMore: true));
    currentPage++;

    var apiResult = await getMoviesListUseCase.call(page:  currentPage , queryTerm: currentQuery);

    if(apiResult.isSuccess){
      final newMovies = apiResult.getData() ?? [];
      if(newMovies.isEmpty || newMovies.length < 20) hasReachedMax = true;

      currentMovies.addAll(newMovies);
      emit(state.copyWith(searchResult:  Resource.success(List.from(currentMovies)), isFetchingMore: false));
    }else{
        emit(state.copyWith(isFetchingMore: false));
      }
  }
}