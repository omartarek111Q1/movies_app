// import 'package:equatable/equatable.dart';
//
// abstract class ProfileState extends Equatable {
//   const ProfileState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class ProfileInitial extends ProfileState {}
//
// class ProfileLoading extends ProfileState {}
//
// class ProfileLoaded extends ProfileState {
//   final String name;
//   final String avatarUrl;
//   final bool isNetworkImage;
//
//   const ProfileLoaded({
//     required this.name,
//     required this.avatarUrl,
//     required this.isNetworkImage,
//   });
//
//   @override
//   List<Object?> get props => [name, avatarUrl, isNetworkImage];
// }
//
// class ProfileError extends ProfileState {
//   final String message;
//
//   const ProfileError(this.message);
//
//   @override
//   List<Object?> get props => [message];
// }
//
//

import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';
import 'package:movies_app/network/resource.dart';

// كلاس صغير يشيل بيانات اليوزر عشان نحطه جوه الـ Resource
class UserProfileData {
  final String name;
  final String avatarUrl;
  final bool isNetworkImage;

  UserProfileData({
    required this.name,
    required this.avatarUrl,
    required this.isNetworkImage,
  });
}

class ProfileState {
  final Resource<UserProfileData> userData;
  final Resource<List<MovieEntity>> favorites;
  final Resource<List<MovieEntity>> bookmarks;

  ProfileState({
    required this.userData,
    required this.favorites,
    required this.bookmarks,
  });

  factory ProfileState.initial() => ProfileState(
    userData: Resource.initial(),
    favorites: Resource.initial(),
    bookmarks: Resource.initial(),
  );

  ProfileState copyWith({
    Resource<UserProfileData>? userData,
    Resource<List<MovieEntity>>? favorites,
    Resource<List<MovieEntity>>? bookmarks,
  }) {
    return ProfileState(
      userData: userData ?? this.userData,
      favorites: favorites ?? this.favorites,
      bookmarks: bookmarks ?? this.bookmarks,
    );
  }
}
