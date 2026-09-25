import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String avatarUrl;
  final bool isNetworkImage;

  const ProfileLoaded({
    required this.name,
    required this.avatarUrl,
    required this.isNetworkImage,
  });

  @override
  List<Object?> get props => [name, avatarUrl, isNetworkImage];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}


