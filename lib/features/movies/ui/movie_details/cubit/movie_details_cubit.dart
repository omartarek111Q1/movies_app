import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/movies/domain/entity/movie_details_entity.dart';
import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/features/movies/domain/usecases/get_movie_details_use_case.dart';
import 'package:movies_app/features/movies/domain/usecases/get_movie_suggestions_use_case.dart';
import 'package:movies_app/network/api_result.dart';
import 'package:movies_app/network/resource.dart';

import '../../../domain/usecases/book_mark_use_case.dart';
import '../../../domain/usecases/favorite_use_case.dart';
import 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final GetMovieDetailsUseCase _getMovieDetailsUseCase;
  final GetMovieSuggestionsUseCase _getMovieSuggestionsUseCase;
  final FavoriteUseCase _favoriteUseCase;
  final BookMarkUseCase _bookMarkUseCase;

  MovieDetailsCubit(
    this._getMovieDetailsUseCase,
    this._getMovieSuggestionsUseCase,
  this._favoriteUseCase,
  this._bookMarkUseCase,
  ) : super(MovieDetailsState.initial());

  Future<void> fetchScreenData(int movieId) async {
    emit(state.copyWith(
      movieDetails: Resource.loading(),
      similarMovies: Resource.loading(),
    ));

    final results = await Future.wait([
      _getMovieDetailsUseCase(movieID: movieId),
      _getMovieSuggestionsUseCase(movieID: movieId),
      _favoriteUseCase.checkIsFavorite(movieId),
      _bookMarkUseCase.checkIsBookmarked(movieId),
      _favoriteUseCase.getFavoriteCount(movieId),
    ]);

    final detailsResult = results[0];
    final suggestionsResult = results[1];
    final isFavResult = results[2];
    final isBookResult = results[3];
    final favCountResult = results[4];

    Resource<MovieDetailsEntity> detailsResource;
    if (detailsResult is SuccessApiResult<MovieDetailsEntity>) {
      detailsResource = Resource.success(detailsResult.data!);
    } else {
      detailsResource = Resource.error("Failed to load details");
    }

    Resource<List<MovieEntity>> suggestionsResource;
    if (suggestionsResult is SuccessApiResult<List<MovieEntity>>) {
      suggestionsResource = Resource.success(suggestionsResult.data!);
    } else {
      suggestionsResource = Resource.error("Failed to load suggestions");
    }

    bool isFavorite = false;
    if (isFavResult is SuccessApiResult<bool>) {
      isFavorite = isFavResult.data ?? false;
    }

    bool isBookMarked = false;
    if (isBookResult is SuccessApiResult<bool>) {
      isBookMarked = isBookResult.data ?? false;
    }

    int favoriteCount = 0;
    if (favCountResult is SuccessApiResult<int>) {
      favoriteCount = favCountResult.data ?? 0;
    }

    emit(state.copyWith(
      movieDetails: detailsResource,
      similarMovies: suggestionsResource,
      isFavorite: isFavorite,
      isBookMarked: isBookMarked,
      favoriteCount: favoriteCount,
    ));
  }

  Future<void> toggleFavorite() async {
    final movie = state.movieDetails.data;
    if (movie == null) return;

    final newFavoriteState = !state.isFavorite;
    final newCount = newFavoriteState ? state.favoriteCount + 1 : state.favoriteCount - 1;

    emit(state.copyWith(
        isFavorite: newFavoriteState,
        favoriteCount: newCount
    ));

    final result = await _favoriteUseCase.toggleFavorite(movie, !newFavoriteState);

    // إذا فشل الطلب، نعود للحالة السابقة بصمت
    if (result is FailureApiResult) {
      emit(state.copyWith(
          isFavorite: !newFavoriteState,
          favoriteCount: state.favoriteCount
      ));
    }
  }

  Future<void> toggleBookmark() async {
    final movie = state.movieDetails.data;
    if (movie == null) return;

    final newBookmarkState = !state.isBookMarked;
    emit(state.copyWith(isBookMarked: newBookmarkState));

    final result = await _bookMarkUseCase.toggleBookmark(movie, !newBookmarkState);

    if (result is FailureApiResult) {
      emit(state.copyWith(isBookMarked: !newBookmarkState));
    }
  }
}

