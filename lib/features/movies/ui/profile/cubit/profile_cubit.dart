import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/features/movies/domain/usecases/favorite_use_case.dart';
import 'package:movies_app/network/api_result.dart';
import 'package:movies_app/network/resource.dart';
import '../../../domain/usecases/book_mark_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FavoriteUseCase _favoriteUseCase;
  final BookMarkUseCase _bookmarkUseCase;

  StreamSubscription? _favoritesSubscription;
  StreamSubscription? _bookmarksSubscription;

  ProfileCubit(
      this._favoriteUseCase,
      this._bookmarkUseCase,
      ) : super(ProfileState.initial());

  Future<void> fetchProfileData() async {
    emit(state.copyWith(
      userData: Resource.loading(),
      favorites: Resource.loading(),
      bookmarks: Resource.loading(),
    ));

    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(state.copyWith(
          userData: Resource.error('User not logged in'),
          favorites: Resource.error('User not logged in'),
          bookmarks: Resource.error('User not logged in'),
        ));
        return;
      }

      final userResult = await _fetchUserDataFromFirebase(currentUser);
      emit(state.copyWith(userData: Resource.success(userResult)));


      _favoritesSubscription?.cancel();
      _favoritesSubscription = _favoriteUseCase.getFavoriteMovies().listen((result) {
        if (result is SuccessApiResult<List<MovieEntity>>) {
          emit(state.copyWith(favorites: Resource.success(result.data!)));
        } else if (result is FailureApiResult) {
          emit(state.copyWith(favorites: Resource.error(result.errorMessage)));
        }
      });

      _bookmarksSubscription?.cancel();
      _bookmarksSubscription = _bookmarkUseCase.getBookmarkedMovies().listen((result) {
        if (result is SuccessApiResult<List<MovieEntity>>) {
          emit(state.copyWith(bookmarks: Resource.success(result.data!)));
        } else if (result is FailureApiResult) {
          emit(state.copyWith(bookmarks: Resource.error(result.errorMessage)));
        }
      });

    } catch (e) {
      emit(state.copyWith(
        userData: Resource.error(e.toString()),
        favorites: Resource.error(e.toString()),
        bookmarks: Resource.error(e.toString()),
      ));
    }
  }

  Future<UserProfileData> _fetchUserDataFromFirebase(User currentUser) async {
    String name = 'User';
    String avatarUrl = 'assets/images/avatar_1.png';
    bool isNetworkImage = false;

    if (currentUser.photoURL != null && currentUser.photoURL!.isNotEmpty) {
      avatarUrl = currentUser.photoURL!;
      isNetworkImage = avatarUrl.startsWith('http');
    }
    if (currentUser.displayName != null && currentUser.displayName!.isNotEmpty) {
      name = currentUser.displayName!;
    }

    if (!isNetworkImage || name == 'User') {
      final doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (!isNetworkImage) {
          avatarUrl = data['avatar'] ?? avatarUrl;
          isNetworkImage = avatarUrl.startsWith('http');
        }
        if (name == 'User') {
          name = data['name'] ?? name;
        }
      }
    }

    return UserProfileData(
      name: name,
      avatarUrl: avatarUrl,
      isNetworkImage: isNetworkImage,
    );
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    _bookmarksSubscription?.cancel();
    return super.close();
  }
}