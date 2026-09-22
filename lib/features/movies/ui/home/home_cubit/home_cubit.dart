import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/movies/domain/usecases/get_movies_list_use_case.dart';
import '../../../../../network/resource.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetMoviesListUseCase _getMoviesListUseCase;

  HomeCubit(this._getMoviesListUseCase) : super(HomeState.initial());

  void getHomeData(){
    getAvailableNowMovies();
    getActionMovies();
    getComedyMovies();
  }

  Future<void> getAvailableNowMovies() async {
    emit(state.copyWith(availableNowMovies: Resource.loading()));

    var apiResult = await _getMoviesListUseCase.call(page: 1 ,sortBy: 'year');

    if (apiResult.isSuccess) {
      emit(state.copyWith(
        availableNowMovies: Resource.success(apiResult.getData() ?? []),
      ));
    } else {
      emit(state.copyWith(
        availableNowMovies: Resource.error(apiResult.errorMessage),
      ));
    }
  }

  Future<void> getActionMovies() async {
    emit(state.copyWith(actionMovies: Resource.loading()));

    var apiResult = await _getMoviesListUseCase.call(page: 2 , genre: 'action');

    if (apiResult.isSuccess) {
      emit(state.copyWith(
        actionMovies: Resource.success(apiResult.getData() ?? []),
      ));
    } else {
      emit(state.copyWith(
        actionMovies: Resource.error(apiResult.errorMessage),
      ));
    }
  }

  Future<void> getComedyMovies() async {
    emit(state.copyWith(comedyMovies: Resource.loading()));

    var apiResult = await _getMoviesListUseCase.call(page: 3 , genre: 'comedy');

    if (apiResult.isSuccess) {
      emit(state.copyWith(
        comedyMovies: Resource.success(apiResult.getData() ?? []),
      ));
    } else {
      emit(state.copyWith(
        comedyMovies: Resource.error(apiResult.errorMessage),
      ));
    }
  }
}