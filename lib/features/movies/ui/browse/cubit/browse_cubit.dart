import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/features/movies/domain/usecases/get_movies_list_use_case.dart';
import 'package:movies_app/features/movies/ui/browse/cubit/browse_state.dart';
import 'package:movies_app/network/resource.dart';

class BrowseCubit  extends Cubit<BrowseState>{
  final GetMoviesListUseCase getMoviesListUseCase;
  int currentPage = 1;
  final List<MovieEntity> currentMovies = [];
  bool hasReachedMax = false;

  final List<String> genres = [
    'Action', 'Adventure', 'Animation', 'Biography',
    'Comedy', 'Crime', 'Documentary', 'Drama',
    'Family', 'Fantasy', 'History', 'Horror',
    'Music', 'Mystery', 'Romance', 'Sci-Fi',
    'Sport', 'Thriller', 'War', 'Western'
  ];
  BrowseCubit(this.getMoviesListUseCase) : super(BrowseState.initial());

  Future<void> getMovieByGenres(String genre) async{
    currentPage = 1;
    currentMovies.clear();
    hasReachedMax = false;

    emit(state.copyWith(
      selectedGenre: genre,
      moviesResult: Resource.loading()
    ));

    var apiResult = await getMoviesListUseCase.call(
      page: currentPage,
      genre: genre.toLowerCase()
    );

    if(isClosed) return;

    if(apiResult.isSuccess){
      final newMovies = apiResult.getData() ?? [];
      currentMovies.addAll(newMovies);
      if(newMovies.isEmpty || newMovies.length < 20) hasReachedMax = true;
      emit(state.copyWith(moviesResult: Resource.success(List.from(currentMovies))));
    }else{
      emit(state.copyWith(moviesResult: Resource.error(apiResult.errorMessage)));
    }
  }

  Future<void> loadMore() async{
    if(state.isFetchingMore || hasReachedMax || state.moviesResult.status == Resource.loading) return;

    emit(state.copyWith(isFetchingMore: true));
    currentPage++;

    var apiResult = await getMoviesListUseCase.call(page:  currentPage , genre: state.selectedGenre.toLowerCase());

    if(isClosed) return;
    if(apiResult.isSuccess){
      final newMovies = apiResult.getData() ?? [];
      if(newMovies.isEmpty || newMovies.length < 20) hasReachedMax = true;

      currentMovies.addAll(newMovies);
      emit(state.copyWith(moviesResult:  Resource.success(List.from(currentMovies)), isFetchingMore: false));
    }else{
      emit(state.copyWith(isFetchingMore: false));
    }
  }
}